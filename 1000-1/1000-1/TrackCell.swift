//
//  TrackCell.swift
//  1000-1
//
//  Created by 魏雄飞 on 2016/12/20.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
    func cancelTapped(_ cell: TrackCell)
    func downloadTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    var delegate: TrackCellDelegate?
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 10, width: 160, height: 30)
        label.numberOfLines = 1
        label.backgroundColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.blue
        self.contentView.addSubview(label)
        
        return label
    }()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 50, width: 160, height: 30)
        label.numberOfLines = 1
        label.backgroundColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.blue
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.frame = CGRect.init(x: 10, y: 105, width: 160, height: 10)
        progressView.progressViewStyle = UIProgressViewStyle.bar
        progressView.progress = 0.5
        progressView.progressTintColor = UIColor.red
        self.contentView.addSubview(progressView)
        
        return progressView
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 180, y: 90, width: 130, height: 30)
        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.blue
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: 180, y: 10, width: 60, height: 30)
        button.setTitle("Pause", for: UIControlState.normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(pauseOrResumeTapped), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    func pauseOrResumeTapped() {
        if pauseButton.titleLabel!.text == "Pause" {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: 250, y: 10, width: 60, height: 30)
        button.setTitle("Cancel", for: UIControlState.normal)
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(cancelTapped), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    func cancelTapped() {
        delegate?.cancelTapped(self)
    }
    
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect.init(x: 180, y: 50, width: 130, height: 30)
        button.setTitle("Download", for: UIControlState.normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(downloadTapped), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()
    
    func downloadTapped() {
        delegate?.downloadTapped(self)
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
