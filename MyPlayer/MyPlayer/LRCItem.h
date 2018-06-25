//
//  LRCItem.h
//  MyPlayer
//
//  Created by Apple on 2018/5/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRCItem : NSObject
//歌词出现时间
@property(nonatomic) float time;
//歌词文字
@property(nonatomic, copy) NSString * lrc;
//排序方法，用于行歌词数据模型的排序，这个方法将按照时间先后进行排序
-(BOOL)isTimeOlderThanAnother:(LRCItem *)item;
@end
