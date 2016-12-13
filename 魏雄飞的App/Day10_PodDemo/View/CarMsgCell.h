//
//  CarMsgCell.h
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 cell的属性声明原则:
 页面上有多少个需要赋值的UI, 就写多少个属性
 */

@interface CarMsgCell : UITableViewCell
@property (nonatomic) UIImageView *iconIV;
@property (nonatomic) UILabel *titleLb;
@property (nonatomic) UILabel *timeLb;
@property (nonatomic) UILabel *replyLb;
@end














