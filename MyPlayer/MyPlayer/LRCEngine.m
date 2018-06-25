//
//  LRCEngine.m
//  MyPlayer
//
//  Created by Apple on 2018/5/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "LRCEngine.h"

@implementation LRCEngine
{
    NSMutableArray * _lrcArray;
}

//歌词引擎初始化，fileName为歌词文件名称
-(instancetype)initWithFile:(NSString *)fileName{
    if (self = [super init]) {
        _lrcArray = [[NSMutableArray alloc]init];
        [self creatDataWithFile:fileName];
    }
    return self;
}

//创建歌词数据
-(void)creatDataWithFile:(NSString *)fileName{
    //读取文件
    NSString * lrcPath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"lrc"];
    NSError * error;
    NSString * dataStr = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:&error];
    //去掉\r
    NSMutableString * tempStr = [[NSMutableString alloc]init];
    NSArray * tmpArray = [dataStr componentsSeparatedByString:@"\r"];
    for (int i = 0; i < tmpArray.count; i++) {
        [tempStr appendString:tmpArray[i]];
    }
    //按照换行符进行字符串分割
    NSArray * lrcArray = [tempStr componentsSeparatedByString:@"\n"];
    //数据解析并将空数据去掉
    for (NSString * lrcStr in lrcArray) {
        if (lrcStr.length == 0) {
            continue;
        }
        //判断是歌词数据还是文件信息数据
        unichar c = [lrcStr characterAtIndex:1];
        if (c >= '0' && c <= '9') {
            //是歌词数据
            [self getLrcData:lrcStr];
        }else{
            //是文件信息数据
            [self getInfoData:lrcStr];
        }
    }
    //进行歌词数据的重新排序
    [_lrcArray sortedArrayUsingSelector:@selector(isTimeOlderThanAnother:)];
}

//创建歌词数据
-(void)getLrcData:(NSString *)lrcStr{
    //按照]进行分隔
    NSArray * arr = [lrcStr componentsSeparatedByString:@"]"];
    //解析时间，同一行歌词可能对应多个时间，最后一个元素是歌词
    for (int i = 0; i < arr.count - 1; i++) {
        //去掉[号
        NSString * timeStr = [arr[i] substringFromIndex:1];
        //把时间字符串转为以s为单位
        NSArray * timeArr =[timeStr componentsSeparatedByString:@":"];
        float min = [timeArr[0] floatValue];
        float sec = [timeArr[1] floatValue];
        //创建模型
        LRCItem * item = [[LRCItem alloc]init];
        item.time = min * 60 + sec;
        item.lrc = [arr lastObject];
        [_lrcArray addObject:item];
    }
}

//获取歌词的标题、作者、专辑等信息
-(void)getInfoData:(NSString *)lrcStr{
    NSArray * arr = [lrcStr componentsSeparatedByString:@":"];
    //获取内容长度，带]符号
    NSInteger len = [arr[1] length];
    //查找歌名
    if ([arr[0] isEqualToString:@"[ti"]) {
        _title = [arr[1] substringToIndex:len-1];
    //查找作者
    }else if ([arr[0] isEqualToString:@"[ar"]){
        _author = [arr[1] substringToIndex:len-1];
    //查找专辑
    }else if ([arr[0] isEqualToString:@"[al"]){
        _albume = [arr[1] substringToIndex:len-1];
    }
}

//通过传入一个时间来获取对应的歌词，handle函数中，lrcArray为按时间排序的每行歌词数据，currentIndex为歌词在数组中的位置
-(void)getCurrentLrcInLRCArray:(void(^)(NSArray * lrcArray, int currentIndex))handle atTime:(float)time{
    //如果数组空则直接返回
    if (!_lrcArray.count) {
        handle(nil, 0);
    }
    
    //找到第一个时间大于time的歌词位置
    int index = -2;
    for (int i = 0; i < _lrcArray.count; i++) {
        float lrcTime = [_lrcArray[i] time];
        if (lrcTime > time) {
            index = i - 1;
            break;
        }
    }
    if (index == -1) {
        //第一条数据
        index = 0;
    }else if (index == -2){
        //没有更大的时间了，最后一条数据
        index = (int)_lrcArray.count-1;
    }
    handle(_lrcArray, index);
}



















@end
