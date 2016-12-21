//
//  Track.swift
//  1000-1
//
//  Created by 魏雄飞 on 2016/12/20.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import UIKit

class Track: NSObject {
    var name: String?
    var artist: String?
    var previewUrl: String?
    
    init(name: String?, artist: String?, previewUrl: String?) {
        self.name = name
        self.artist = artist
        self.previewUrl = previewUrl
    }

}
