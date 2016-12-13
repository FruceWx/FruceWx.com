//
//  NetManager.h
//  Day09_NewsList
//
//  Created by tarena on 16/9/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "BaseNetManager.h"
#import "CarMsgListModel.h"

typedef NS_ENUM(NSUInteger, MsgType) {
    MsgTypeZuiXin,
    MsgTypeXinWen,
    MsgTypePingCe,
    MsgTypeDaoGou,
    MsgTypeHangQing,
    MsgTypeYongChe,
    MsgTypeJiShu,
    MsgTypeWenHua,
    MsgTypeGaiZhuang,
    MsgTypeYouJi,
};

@interface NetManager : BaseNetManager

+ (id)getCarMsgListWithPage:(NSInteger)page lasttime:(NSString *)lasttime msgType:(MsgType)msgType handler:(void(^)(CarMsgListModel *model, NSError *error))handler;


@end











