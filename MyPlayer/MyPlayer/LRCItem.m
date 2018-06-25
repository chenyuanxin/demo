//
//  LRCItem.m
//  MyPlayer
//
//  Created by Apple on 2018/5/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "LRCItem.h"

@implementation LRCItem
//排序方法，用于行歌词数据模型的排序，这个方法将按照时间先后进行排序
-(BOOL)isTimeOlderThanAnother:(LRCItem *)item{
    return self.time > item.time;
}
@end
