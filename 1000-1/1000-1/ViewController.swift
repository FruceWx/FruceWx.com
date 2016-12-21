//
//  ViewController.swift
//  1000-1
//
//  Created by 魏雄飞 on 2016/12/20.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: 104, width: self.view.bounds.size.width, height: self.view.bounds.size.height), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect.init(x: 0, y: 64, width: self.view.bounds.size.width, height: 40)
        searchBar.delegate = self
        
        return searchBar
    }()
    
    let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var searchResults = [Track]()
    var activeDownloads = [String: Download]()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        return recognizer
    }()
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    lazy var downloadsSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
//MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TrackCell.classForCoder(), forCellReuseIdentifier: "TrackCell")
        self.tableView.isHidden = false
        self.view.addSubview(searchBar)
        _ = self.downloadsSession
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                        }else {
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
            download.downloadTask = downloadsSession.downloadTask(with: url)
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
            }
            
            download.isDownloading = false
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
                download.downloadTask = downloadsSession.downloadTask(withResumeData: resumeData)
                download.downloadTask!.resume()
                download.isDownloading = true
            } else if let url = URL(string: download.url) {
                download.downloadTask = downloadsSession.downloadTask(with: url)
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
    
    func trackIndexforDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in searchResults.enumerated() {
                if url == track.previewUrl! {
                    return index
                }
            }
        }
        return nil
    }
    


}
//MARK:-------------------------------------------------------------------------

//MARK: URLSessionDelegate
extension ViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
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

//MARK: URLSessionDownloadDelegate
extension ViewController: URLSessionDownloadDelegate {
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
            if let trackIndex = trackIndexforDownloadTask(downloadTask) {
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
                })
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString, let download = activeDownloads[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            let totaSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            if let trackIndex = trackIndexforDownloadTask(downloadTask), let trackCell = tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? TrackCell {
                DispatchQueue.main.async(execute: { 
                    trackCell.progressView.progress = download.progress
                    trackCell.progressLabel.text = String(format: "%.1f%% of %@", download.progress * 100, totaSize)
                })
            }
        }
    }
    
    
    
}

//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        if !searchBar.text!.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let expectedCharSet = CharacterSet.urlQueryAllowed
            let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters:expectedCharSet)!
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

//MARK: TrackCellDelegate
extension ViewController: TrackCellDelegate {
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



//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        cell.delegate = self
        
        
        let track = searchResults[(indexPath as NSIndexPath).row]
        
        cell.titleLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        var showDownloadControls = false
        
        if let download = activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            cell.progressView.progress = download.progress
            cell.progressLabel.text = (download.isDownloading) ? "Downloading" : "Pause"
            
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, for: UIControlState())
        }
        
        cell.progressView.isHidden = !showDownloadControls
        cell.progressLabel.isHidden = !showDownloadControls
        
        let downloaded = localFileExistsForTrack(track)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        cell.downloadButton.isHidden = downloaded || showDownloadControls
        cell.pauseButton.isHidden = !showDownloadControls
        cell.cancelButton.isHidden = !showDownloadControls
        
        
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let track = searchResults[(indexPath as NSIndexPath).row]
        if localFileExistsForTrack(track) {
            playDownload(track)
        }
    }
    
    
}


