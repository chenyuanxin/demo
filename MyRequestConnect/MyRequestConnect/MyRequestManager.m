//
//  MyRequestManager.m
//  MyRequestConnect
//
//  Created by Apple on 2018/4/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MyRequestManager.h"
#import "MyRequestConnection.h"

@implementation MyRequestManager
{
    //存放请求的连接对象
    NSMutableArray * _requestConnectionArray;
}

+(MyRequestManager *)shareManager{
    static MyRequestManager * manager = nil;
    static dispatch_once_t predicate;
    //确保只执行一次
    dispatch_once(&predicate, ^{
        manager = [[MyRequestManager alloc]init];
    });
    return manager;
}

//初始化连接缓存数组
-(instancetype)init{
    if (self) {
        _requestConnectionArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addRequestToManager:(NSString *)urlStr finished:(void (^)(BOOL, NSData *))finish{
    //如果有相同的连接请求则直接返回，不做处理
    for (MyRequestConnection * connection in _requestConnectionArray) {
        if ([connection.urlStr isEqualToString:urlStr]) {
            return;
        }
    }
    //
    MyRequestConnection * connection = [[MyRequestConnection alloc]init];
    if (self.HTTPHeadersDic) {
        connection.HTTPHeadersDic = self.HTTPHeadersDic;
        
    }
    [_requestConnectionArray addObject:connection];
    [connection startRequestWithURLString:urlStr finished:^(BOOL success, NSData *data) {
        [_requestConnectionArray removeObject:connection];
        finish(success, data);
    }];
}
@end










