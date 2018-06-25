//
//  LRCEngine.h
//  MyPlayer
//
//  Created by Apple on 2018/5/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRCItem.h"

@interface LRCEngine : NSObject
//歌词引擎初始化，fileName为歌词文件名称
-(instancetype)initWithFile:(NSString *)fileName;
//歌手名字
@property(nonatomic, strong)NSString * author;
//专辑名称
@property(nonatomic, strong)NSString * albume;
//歌曲名称
@property(nonatomic, strong)NSString * title;
//通过传入一个时间来获取对应的歌词，handle函数中，lrcArray为按时间排序的每行歌词数据，currentIndex为歌词在数组中的位置
-(void)getCurrentLrcInLRCArray:(void(^)(NSArray * lrcArray, int currentIndex))handle atTime:(float)time;
@end
