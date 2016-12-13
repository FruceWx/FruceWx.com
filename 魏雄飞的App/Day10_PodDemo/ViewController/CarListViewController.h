//
//  CarListViewController.h
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetManager.h"


@interface CarListViewController : UITableViewController

- (instancetype)initWithMsgType:(MsgType)msgType;
@property (nonatomic) MsgType msgType;

@end
