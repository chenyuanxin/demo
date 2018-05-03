//
//  MyNetworking.h
//  MyAFNW
//
//  Created by Apple on 2018/5/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNetworking : NSObject
@property(nonatomic, strong)NSDictionary * HTTPHeadersDic;
+(MyNetworking *)sharedNetWorking;
+(void)getRequestWithURLString:(NSString *)urlStr finish:(void(^)(BOOL success, NSData * data))finish;
+(void)postRequestWithURLString:(NSString *)urlStr paramDic:(NSDictionary *)param finish:(void(^)(BOOL success, NSData * data))finish;
@end
