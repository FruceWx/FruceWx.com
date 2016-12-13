//
//  BaseNetManager.m
//  Day08_Heroes
//
//  Created by tarena on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "BaseNetManager.h"

@implementation BaseNetManager


+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 30;
    
    return [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //为了方便调试,打印请求的路径
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}
@end







