//
//  TrackCell.swift
//  Swift_Test_day12-16-1
//
//  Created by 魏雄飞 on 2016/12/16.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
    func pauseTapped(_ cell:TrackCell)
    func resumeTapped(_ cell:TrackCell)
    func cancelTapped(_ cell:TrackCell)
    func downloadTapped(_ cell:TrackCell)
}

class TrackCell: UITableViewCell {
    var delegate:TrackCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    
    @IBAction func pauseOrResumeTapped(_ sender: UIButton) {
        
        if pauseButton.titleLabel!.text == "pause" {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: UIButton) {
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










