//
//  MyRequestManager.h
//  MyRequestConnect
//
//  Created by Apple on 2018/4/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRequestManager : NSObject
+(MyRequestManager *)shareManager;
-(void)addRequestToManager:(NSString *)urlStr finished:(void(^)(BOOL success, NSData * data))finish;
@property(nonatomic, strong)NSDictionary * HTTPHeadersDic;
@end
