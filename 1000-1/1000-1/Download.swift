//
//  Download.swift
//  1000-1
//
//  Created by 魏雄飞 on 2016/12/20.
//  Copyright © 2016年 Fruce.Wei. All rights reserved.
//

import UIKit

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
