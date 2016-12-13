//
//  NetManager.m
//  Day09_NewsList
//
//  Created by tarena on 16/9/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NetManager.h"

#define kZuiXinPath  @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt0-p%ld-s30-l%@.json"

#define kXinWenPath  @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt1-p%ld-s30-l%@.json"

#define kPingCePath   @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt3-p%ld-s30-l%@.json"
#define kDaoGouPath   @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt60-p%ld-s30-l%@.json"
#define kHangQingPath  @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c110100-nt2-p%ld-s30-l%@.json"
#define kYongChePath   @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt82-p%ld-s30-l%@.json"
#define kJiShuPath    @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt102-p%ld-s30-l%@.json"
#define kWenHuaPath   @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt97-p%ld-s30-l%@.json"
#define kGaiZhuangCePath @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt107-p%ld-s30-l%@.json"
#define kYouJiPath       @"http://app.api.autohome.com.cn/autov5.0.0/news/newslist-pm1-c0-nt100-p%ld-s30-l%@.json"



@implementation NetManager
+ (id)getCarMsgListWithPage:(NSInteger)page lasttime:(NSString *)lasttime msgType:(MsgType)msgType handler:(void (^)(CarMsgListModel *, NSError *))handler{
    NSString *path = nil;
    switch (msgType) {
        case MsgTypeZuiXin: {
            path = kZuiXinPath;
            break;
        }
        case MsgTypeXinWen: {
            path = kXinWenPath;
            break;
        }
        case MsgTypePingCe: {
            path = kPingCePath;
            break;
        }
        case MsgTypeDaoGou: {
            path = kDaoGouPath;
            break;
        }
        case MsgTypeHangQing: {
            path = kHangQingPath;
            break;
        }
        case MsgTypeYongChe: {
            path = kYongChePath;
            break;
        }
        case MsgTypeJiShu: {
            path = kJiShuPath;
            break;
        }
        case MsgTypeWenHua: {
            path = kWenHuaPath;
            break;
        }
        case MsgTypeGaiZhuang: {
            path = kGaiZhuangCePath;
            break;
        }
        case MsgTypeYouJi: {
            path = kXinWenPath;
            break;
        }
    }
    path = [NSString stringWithFormat:path, page, lasttime];
    
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        !handler ?: handler([CarMsgListModel parse:responseObj], error);
    }];
}

@end






