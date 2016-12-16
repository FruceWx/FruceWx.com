//
//  SearchViewController.swift
//  Swift_Test_day12-16-1
//
//  Created by 魏雄飞 on 2016/12/16.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    
    var dataTask: URLSessionDataTask?
    
    var searchResults = [Track]()
    
    var activeDownloads = [String: Download]()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recoginzer = UITapGestureRecognizer(target:self, action: #selector(SearchViewController.dismissKeyboard))
        
        return recoginzer
    }()
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    // 延迟计算型属性：后台下载任务对应的session
    lazy var downloadSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = self.searchBar
        _ = self.downloadSession
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 服务器成功返回解析JSON数据
    func updateSearchResults(_ data: Data?) {
        searchResults.removeAll()
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] {
                if let array: AnyObject = response["results"] {
                    for trackDictionary in array as! [AnyObject] {
                        if let trackDictionary = trackDictionary as? [String: AnyObject], let previewUrl = trackDictionary["previewUrl"] as? String {
                            let name = trackDictionary["trackName"] as? String
                            let artist = trackDictionary["artistName"] as? String
                            
                            searchResults.append(Track(name: name, artist: artist, previewUrl: previewUrl))
                        } else {
                            print("Not a dictionary")
                        }
                    }
                } else {
                    print("Results key not found in dictionary")
                }
            } else {
                print("JSON Error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    func startDownload(_ track: Track) {
        if let urlString = track.previewUrl, let url = URL(string: urlString) {
            let download = Download(url: urlString)
            download.downloadTask = downloadSession.downloadTask(with: url)
            download.downloadTask!.resume()
            download.isDownloading = true
            activeDownloads[download.url] = download
        }
    }
    
    func pauseDownload(_ track: Track) {
        if let urlString = track.previewUrl, let download = activeDownloads[urlString] {
            if download.isDownloading {
                download.downloadTask?.cancel { data in
                    if data != nil {
                        download.resumeData = data
                    }
                }
                download.isDownloading = false
            }
        }
    }
    
    func cancelDownload(_ track: Track) {
        if let urlString = track.previewUrl, let download = activeDownloads[urlString] {
            download.downloadTask?.cancel()
            activeDownloads[urlString] = nil
        }
    }
    
    func resumeDownload(_ track: Track) {
        if let urlString = track.previewUrl, let download = activeDownloads[urlString] {
            if let resumeData = download.resumeData {
                download.downloadTask = downloadSession.downloadTask(withResumeData: resumeData)
                download.downloadTask!.resume()
                download.isDownloading = true
            } else if let url = URL(string: download.url) {
                download.downloadTask = downloadSession.downloadTask(with: url)
                download.downloadTask!.resume()
                download.isDownloading = true
            }
        }
    }
    
    func playDownload(_ track: Track) {
        if let urlString = track.previewUrl, let url = localFilePathForUrl(urlString) {
            let moviePlayer: AVPlayerViewController = AVPlayerViewController()
            moviePlayer.player = AVPlayer(url: url)
            
            present(moviePlayer, animated: true, completion: nil)
        }
    }
    
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = URL(string: previewUrl) {
            let fullPath = documentsPath.appendingPathComponent(url.lastPathComponent)
            return URL(fileURLWithPath: fullPath)
        }
        return nil
    }
    
    func localFileExistsForTrack(_ track: Track) -> Bool {
        if let urlString = track.previewUrl, let localUrl = localFilePathForUrl(urlString) {
            var isDir: ObjCBool = false
            return FileManager.default.fileExists(atPath: localUrl.path, isDirectory: &isDir)
        }
        return false
    }
    
    func trackIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in searchResults.enumerated() {
                if url == track.previewUrl! {
                    return index
                }
            }
            
        }
        return nil
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TrackCell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        cell.delegate = self
        
        let track = searchResults[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        var showDownloadControls = false
        
        if let download = activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            
            cell.progressView.progress = download.progress
            cell.progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, for: UIControlState())
        }
        
        cell.progressView.isHidden = !showDownloadControls
        cell.progressLabel.isHidden = !showDownloadControls
        
        let downloaded = localFileExistsForTrack(track)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        
        cell.downloadButton.isHidden = downloaded || showDownloadControls
        
        cell.pauseButton.isHidden = !showDownloadControls
        cell.playButton.isHidden = !showDownloadControls
            
            
        return cell
        
        
    }
    

}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        if !searchBar.text!.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let expectedCharSet = CharacterSet.urlQueryAllowed
            let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
            
            let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm)")
            dataTask = defaultSession.dataTask(with: url!, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.updateSearchResults(data)
                    }
                }
            })
            
            dataTask?.resume()
            
        }
 
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
}

extension SearchViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("URLSessionDidFinishEventsForBackgroundURLSession")
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async(execute: {
                    completionHandler()
                })
            }
        }
    }
}

extension SearchViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString, let destinationURL = localFilePathForUrl(originalURL) {
            print(destinationURL)
            let fileManager = FileManager.default
            
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            activeDownloads[url] = nil
            if let trackIndex = trackIndexForDownloadTask(downloadTask) {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
                })
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString, let download = activeDownloads[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            if let trackIndex = trackIndexForDownloadTask(downloadTask), let trackCell = tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? TrackCell {
                DispatchQueue.main.async(execute: { 
                    trackCell.progressView.progress = download.progress
                    trackCell.progressLabel.text = String(format: "%.1f%% of %@", download.progress * 100, totalSize)
                })
            }
        }
    }
    
    
}
extension SearchViewController: TrackCellDelegate {
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            pauseDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            resumeDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            cancelDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[(indexPath as NSIndexPath).row]
            startDownload(track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    
    
    
}






