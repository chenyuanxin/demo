//
//  MyMusicPlayer.m
//  MyPlayer
//
//  Created by Apple on 2018/5/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MyMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@implementation MyMusicPlayer
{
    //处理音频的播放
    AVAudioPlayer * _player;
    //播放时间的更新
    NSTimer * _timer;
}

//创建定时器，并将当前对象与程序的AppDelegate对象进行了关联
-(instancetype)init{
    self = [super init];
    if (self) {
        //创建定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        delegate.play = self;
    }
    return self;
}

//定时器刷新时间
-(void)update{
    if (_player) {
        _hadPlayTime = _player.currentTime;
    }
}

//进行播放与暂停的切换
-(void)playOrStop{
    //先判断是否正在播放
    if (self.isPlaying) {
        //已经在播放，则进行停止播放操作
        [self stop];
    }else{
        //没有播放，则进行播放操作
        [self paly];
    }
}

//播放音频
-(void)play{
    //判断AVAudioPlayer对象是否存在
    if (_player != nil) {
        [_player play];
        _isPlaying = YES;
        return;
    }else{
        //从歌曲数组中读取第一个元素
        NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:0] ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url  error:nil];
        _player.delegate = self;
        [_player play];
        _isPlaying = YES;
        _currentIndex = 0;
        _currentSongTime = _player.duration;
    }
}

//停止音频播放
-(void)stop{
    if (_player.isPlaying) {
        [_player stop];
        _isPlaying = NO;
    }
}

//结束播放
-(void)end{
    [_player stop];
    _isPlaying = NO;
    _player = nil;
}

//播放指定的第几首歌
-(void)playAtIndex:(int)index isPlay:(BOOL)play{
    [_player stop];
    _isPlaying = NO;
    _player = nil;
    NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:index] ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    if (play) {
        [_player play];
        _isPlaying = YES;
    }
    _currentIndex = index;
    _currentSongTime = _player.duration;
}

//播放下一首
-(void)nextMusic{
    BOOL bePlay = _player.isPlaying;
    [_player stop];
    _isPlaying = NO;
    _player = nil;
    //是否最后一曲
    if (_currentIndex < self.songsArray.count - 1) {
        _currentIndex++;
    }else{
        _currentIndex = 0;
    }
    //是否随机播放
    if (self.isRandom) {
        unsigned long max = self.songsArray.count;
        _currentIndex = arc4random() % max;
    }
    NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url  error:nil];
    _currentSongTime = _player.duration;
    _player.delegate = self;
    if (bePlay) {
        [_player play];
        _isPlaying = YES;
    }
}

//上一首
-(void)lastMusic{
    BOOL bePlay = _player.isPlaying;
    [_player stop];
    _isPlaying = NO;
    _player = nil;
    //如果到底了，则循环
    if (_currentIndex > 0) {
        _currentIndex--;
    }else{
        _currentIndex = (int)_songsArray.count - 1;
    }
    //如果是随机播放则计算一个随机的序号
    if (self.isRandom) {
        unsigned long max = self.songsArray.count;
        _currentIndex = arc4random() % max;
    }
    NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _currentSongTime = _player.duration;
    _player.delegate = self;
    if (bePlay) {
        [_player play];
        _isPlaying = YES;
    }
}

//歌曲播放结束时调用的代理
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _player = nil;
    _isPlaying = NO;
    
    //是否循环播放
    if (_isRandom) {
        unsigned long max = self.songsArray.count;
        int songIndex = arc4random() % max;
        NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:songIndex] ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url  error:nil];
        _player.delegate = self;
        [_player play];
        _isPlaying = YES;
        [self.delegate musicPlayEndAndWillContinuePlaying:YES];
        _currentIndex = songIndex;
        _currentSongTime = _player.duration;
        return;
    }
    
    //不是循环播放时
    if (_currentIndex < self.songsArray.count-1) {
        //是否最后一首
        NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:++_currentIndex] ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url  error:nil];
        _currentSongTime = _player.duration;
        _player.delegate = self;
        [_player play];
        _isPlaying = YES;
        [self.delegate musicPlayEndAndWillContinuePlaying:YES];
    }else if (_currentIndex == self.songsArray.count-1){
        //是否循环
        if (_isRunLoop) {
            _currentIndex = 0;
            NSString * path = [[NSBundle mainBundle]pathForResource:[self.songsArray objectAtIndex:_currentIndex] ofType:@"mp3"];
            NSURL * url = [NSURL fileURLWithPath:path];
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url  error:nil];
            _player.delegate = self;
            _currentSongTime = _player.duration;
            [_player play];
            _isPlaying = YES;
            [self.delegate musicPlayEndAndWillContinuePlaying:YES];
        }else{
            [self.delegate musicPlayEndAndWillContinuePlaying:NO];
        }
    }
}

@end


























