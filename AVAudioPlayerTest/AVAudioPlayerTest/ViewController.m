//
//  ViewController.m
//  AVAudioPlayerTest
//
//  Created by Apple on 2018/5/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
{
    AVAudioPlayer * _player;
    __weak IBOutlet UILabel *timeLabel;
    NSTimer * _timer;
}
@end

@implementation ViewController
//更改音量大小
- (IBAction)voicePowerSlide:(UISlider *)sender {
    float value = sender.value;
    _player.volume = value;
}

//播放音乐
- (IBAction)playMusic:(UIButton *)sender {
    if (_player.playing) {
        return;
    }
    [_player play];
}

//暂停音乐
- (IBAction)pauseMusic:(UIButton *)sender {
    if (_player.isPlaying) {
        [_player pause];
    }
}

//暂停音乐
- (IBAction)stopMusic:(UIButton *)sender {
    if (_player.isPlaying) {
        NSLog(@"停止播放");
        [_player stop];
    }
}

//停止音乐
- (IBAction)tingzhiMusic:(UIButton *)sender {
    if ([_player isPlaying]) {
//        [_player stop];
    }
}


//设置声道
- (IBAction)soundTrack:(UISlider *)sender {
    float value = (sender.value - 0.5) * 2;
    _player.pan = value;
}

//设置播放速度
- (IBAction)soundSpeed:(UISlider *)sender {
    NSLog(@"设置播放速度");
    float value = sender.value + 0.5;
    _player.rate = value;
}

//视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //播放mp3
    NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle]pathForResource:@"说散就散" ofType:@"mp3"]];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    if ([_player prepareToPlay]) {
        [_player play];
    }
    
    //设置定时器，按秒刷新播放时长
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantPast];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //设置歌曲题目
    [dict setObject:@"说散就散" forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [dict setObject:@"袁娅维" forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [dict setObject:@"前任三" forKey:MPMediaItemPropertyAlbumTitle];
    //设置显示的图片
    UIImage * newImage = [UIImage imageNamed:@"说散就散.jpg"];
    [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage] forKey:MPMediaItemPropertyArtwork];
    //设置歌曲时长
    [dict setObject:[NSNumber numberWithDouble:300] forKey:MPMediaItemPropertyPlaybackDuration];
    [dict setObject:[NSNumber numberWithDouble:150] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //更新字典
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:dict];
    
}

//设置音乐播放时间
-(void)updateProgress{
    int current = _player.currentTime;
    int duration = _player.duration;
    timeLabel.text = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", current/60, current%60, duration/60, duration%60];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
