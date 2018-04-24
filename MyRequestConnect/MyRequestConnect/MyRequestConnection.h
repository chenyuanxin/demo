//
//  MyRequestConnection.h
//  MyRequestConnect
//
//  Created by Apple on 2018/4/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRequestConnection : NSObject
-(void)startRequestWithURLString:(NSString *)urlStr finished:(void(^)(BOOL success, NSData * data))finish;
@property(nonatomic, strong)NSDictionary * HTTPHeadersDic;
@property(nonatomic, strong)NSString * urlStr;
@end
