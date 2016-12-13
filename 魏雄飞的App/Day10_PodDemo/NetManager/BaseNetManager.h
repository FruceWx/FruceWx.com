//
//  BaseNetManager.h
//  Day08_Heroes
//
//  Created by tarena on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetManager : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

@end



















