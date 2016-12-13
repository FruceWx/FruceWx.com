//
//  CarMsgListModel.h
//  Day10_PodDemo
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 1. 只有字典才新建类型
 2. 命名要有层次感
 3. 对于数组属性/修改了属性名和key对应的属性要重写方法来进行对应.
 */

@class CarMsgListResultModel,CarMsgListResultHeadlineinfoModel,CarMsgListResultTopnewsinfoModel,CarMsgListResultNewslistModel,CarMsgListResultFocusimgModel;
@interface CarMsgListModel : NSObject

@property (nonatomic, strong) CarMsgListResultModel *result;

@property (nonatomic, assign) NSInteger returncode;

@property (nonatomic, copy) NSString *message;


@end

@interface CarMsgListResultModel : NSObject

@property (nonatomic, assign) BOOL isloadmore;

@property (nonatomic, assign) NSInteger rowcount;

@property (nonatomic, strong) CarMsgListResultHeadlineinfoModel *headlineinfo;

@property (nonatomic, strong) NSArray<CarMsgListResultFocusimgModel *> *focusimg;

@property (nonatomic, strong) NSArray<CarMsgListResultNewslistModel *> *newslist;

@property (nonatomic, strong) CarMsgListResultTopnewsinfoModel *topnewsinfo;

@end

@interface CarMsgListResultHeadlineinfoModel : NSObject

// id -> ID
@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *smallpic;

@property (nonatomic, assign) NSInteger replycount;

@property (nonatomic, copy) NSString *lasttime;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger mediatype;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, assign) NSInteger jumppage;

@property (nonatomic, copy) NSString *indexdetail;

@property (nonatomic, assign) NSInteger pagecount;

@property (nonatomic, strong) NSArray *coverimages;

@end

@interface CarMsgListResultTopnewsinfoModel : NSObject

@end

@interface CarMsgListResultNewslistModel : NSObject

// id -> ID
@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSArray *coverimages;

@property (nonatomic, copy) NSString *smallpic;

@property (nonatomic, assign) NSInteger replycount;

@property (nonatomic, copy) NSString *lasttime;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) NSInteger mediatype;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, assign) NSInteger jumppage;

@property (nonatomic, copy) NSString *indexdetail;

@property (nonatomic, assign) NSInteger pagecount;

@property (nonatomic, assign) NSInteger newstype;

@end

@interface CarMsgListResultFocusimgModel : NSObject

@property (nonatomic, copy) NSString *imgurl;

@property (nonatomic, copy) NSString *jumpurl;

@property (nonatomic, copy) NSString *updatetime;
// id -> ID
@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger replycount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger pageindex;

@property (nonatomic, assign) NSInteger JumpType;

@property (nonatomic, assign) NSInteger mediatype;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger fromtype;

@end

