//
//  MyNetworking.m
//  MyAFNW
//
//  Created by Apple on 2018/5/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MyNetworking.h"
#import <AFNetworking/AFNetworking.h>

@implementation MyNetworking
+(MyNetworking *)sharedNetWorking{
    static MyNetworking * netWorking = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        netWorking = [[MyNetworking alloc]init];
    });
    return netWorking;
}

//get类型的请求
+(void)getRequestWithURLString:(NSString *)urlStr finish:(void (^)(BOOL, NSData *))finish{
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlStr = %@", urlStr);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    if ([MyNetworking sharedNetWorking].HTTPHeadersDic) {
        for (NSString * key in [MyNetworking sharedNetWorking].HTTPHeadersDic) {
            NSLog(@"进入循环: key = %@", [MyNetworking sharedNetWorking].HTTPHeadersDic[key]);
            [manager.requestSerializer setValue:[MyNetworking sharedNetWorking].HTTPHeadersDic[key] forHTTPHeaderField:key];
        }
    }
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"调用成功");
        finish(YES, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"调用失败: %@", error);
        finish(NO, nil);
    }];
}

//post类型的请求
+(void)postRequestWithURLString:(NSString *)urlStr paramDic:(NSDictionary *)param finish:(void (^)(BOOL, NSData *))finish{
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([MyNetworking sharedNetWorking].HTTPHeadersDic) {
        for (NSString * key in [MyNetworking sharedNetWorking].HTTPHeadersDic) {
            [manager.requestSerializer setValue:[MyNetworking sharedNetWorking].HTTPHeadersDic[key] forKey:key];
        }
        [manager POST:urlStr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finish(YES, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finish(NO, nil);
        }];
    }
}
@end
