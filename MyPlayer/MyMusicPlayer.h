//
//  MyMusicPlayer.h
//  MyPlayer
//
//  Created by Apple on 2018/5/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//设置音频文件播放完之后的代理回调，提供给外界进行逻辑操作
//在音频播放完毕后执行，BOOL只参数决定是否自动播放下一个音频数据
@protocol MyMusicPlayerDelegate<NSObject>
-(void)musicPlayEndAndWillContinuePlaying:(BOOL)play;
@end

@interface MyMusicPlayer : NSObject<AVAudioPlayerDelegate>
//歌曲名数组
@property(nonatomic, strong)NSArray * songsArray;
//对应歌曲的歌词名数组
@property(nonatomic, strong)NSArray * lrcsArray;
//是否循环播放
@property(nonatomic, assign)BOOL isRunLoop;
//是否随机播放
@property(nonatomic, assign)BOOL isRandom;
//音频播放器是否正在播放音频
@property(nonatomic, assign)BOOL isPlaying;
//代理对象
@property(nonatomic, weak)id<MyMusicPlayerDelegate> delegate;
//获取当前播放的是第几个音频
@property(nonatomic, assign)int currentIndex;
//当前播放的音频文件的时长
@property(nonatomic, assign)int currentSongTime;
//当前播放的音频文件已经播放的时长
@property(nonatomic, assign)int hadPlayTime;
//开始播放
-(void)paly;
//暂停播放
-(void)stop;
//进行继续播放与暂停播放的切换
-(void)playOrStop;
//上一曲
-(void)lastMusic;
//下一曲
-(void)nextMusic;
//停止播放
-(void)end;
//播放指定的音频文件
-(void)playAtIndex:(int)index isPlay:(BOOL)play;

@property(nonatomic, strong)MyMusicPlayer *play;
@end

















