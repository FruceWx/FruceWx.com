//
//  CarMsgListModel.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CarMsgListModel.h"

@implementation CarMsgListModel

@end

@implementation CarMsgListResultModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"focusimg": @"CarMsgListResultFocusimgModel",
             @"newslist": @"CarMsgListResultNewslistModel"};
}
@end


@implementation CarMsgListResultHeadlineinfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID": @"id"};
}
@end


@implementation CarMsgListResultTopnewsinfoModel
@end


@implementation CarMsgListResultNewslistModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID": @"id"};
}
@end


@implementation CarMsgListResultFocusimgModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID": @"id"};
}
@end


