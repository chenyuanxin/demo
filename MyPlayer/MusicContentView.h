//
//  MusicContentView.h
//  MyPlayer
//
//  Created by Apple on 2018/5/30.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMusicPlayer.h"

@interface MusicContentView : UIView
//歌曲列表数据源数组
@property(nonatomic, strong)NSArray * titleDataArray;
//这个方法设置当前界面显示的歌词，对应歌曲播放的相应时间
-(void)setCurrentLRCArray:(NSArray *)array index:(int)index;
//播放器引擎对象的引用
@property(nonatomic, strong)MyMusicPlayer * play;
//锁屏界面要显示的图片
@property(nonatomic, readonly)UIImage * lrcImage;
@end
