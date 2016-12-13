//
//  WebViewController.h
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
- (instancetype)initWithURL:(NSURL *)webURL;
@property (nonatomic) NSURL *webURL;
@property (nonatomic) NSString *webTitle;
@end
