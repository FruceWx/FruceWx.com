//
//  Download.swift
//  Swift_Test_day12-16-1
//
//  Created by 魏雄飞 on 2016/12/16.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import Foundation

class Download: NSObject {
    var url: String
    var isDownloading = false
    var progress: Float = 0.0
    
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: String) {
        self.url = url
    }

}
