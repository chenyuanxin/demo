//
//  ViewController.m
//  MyPlayer
//
//  Created by Apple on 2018/5/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "LRCEngine.h"
#import "MyMusicPlayer.h"
#import "MusicContentView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>

@interface ViewController ()<MyMusicPlayerDelegate>
{
    MyMusicPlayer * _player;
    //内容视图
    MusicContentView * _contentView;
    //标题标签
    UILabel * _titleLabel;
    //进度条
    UIProgressView * _progresss;
    //播放按钮
    UIButton * _playBtn;
    //下一曲按钮
    UIButton * _nextBtn;
    //上一曲按钮
    UIButton * _lastBtn;
    //循环播放按钮
    UIButton * _circleBtn;
    //随机播放按钮
    UIButton * _randomBtn;
    //存放歌曲名
    NSArray * _dataArray;
    NSTimer * _timer;
    BOOL _isBack;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //播放歌曲
    LRCEngine * engine = [[LRCEngine alloc]initWithFile:@"说散就散"];
    [engine getCurrentLrcInLRCArray:^(NSArray *lrcArray, int currentIndex) {
        if (lrcArray.count > 0) {
            NSLog(@"%@\n=========\n%@", lrcArray, [lrcArray[currentIndex] lrc]);
        }
    } atTime:100];
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneToBack) name:@"goBack" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneToForward) name:@"goForward" object:nil];
    _isBack = NO;
    //创建数据
    [self creatData];
    //创建播放模块
    [self creatPlayer];
    //创建视图模块
    [self creatView];
//    //进行刷新UI操作
//    [self updateUI];
}

//创建数据
-(void)creatData{
    _dataArray = @[@"说散就散", @"红昭愿"];
}

//创建播放模块
-(void)creatPlayer{
    _player = [[MyMusicPlayer alloc]init];
    _player.songsArray = _dataArray;
    NSMutableArray * mulArr = [[NSMutableArray alloc]init];
    for (int i=0; i<_dataArray.count; i++) {
        //进行歌词模块创建
        LRCEngine * engine = [[LRCEngine alloc]initWithFile:_dataArray[i]];
        [mulArr addObject:engine];
    }
    _player.lrcsArray = mulArr;
    _player.delegate = self;
}

//创建视图模块
-(void)creatView{
    //创建背景
    UIImageView * bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"BG.jpeg"];
    //设置为可接收用户交互
    bg.userInteractionEnabled = YES;
    [self.view addSubview:bg];
    //创建歌曲标题Label
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, bg.frame.size.width, 40)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _dataArray[0];
    _titleLabel.backgroundColor = [UIColor clearColor];;
    _titleLabel.textColor = [UIColor whiteColor];
    [bg addSubview:_titleLabel];
    //创建歌曲进度条
    _progresss = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progresss.progressTintColor = [UIColor redColor];
    _progresss.trackTintColor = [UIColor whiteColor];
    _progresss.frame = CGRectMake(20, self.view.frame.size.height-70, self.view.frame.size.width-40, 5);
    [bg addSubview:_progresss];
    //创建播放按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    _playBtn.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height-45, 40, 40);
    [_playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_playBtn];
    //创建下一曲按钮
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(self.view.frame.size.width/2+40, self.view.frame.size.height-45, 40, 40);
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"nextMusic"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_nextBtn];
    //创建上一曲按钮
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastBtn.frame = CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height-45, 40, 40);
    [_lastBtn setBackgroundImage:[UIImage imageNamed:@"aboveMusic"] forState:UIControlStateNormal];
    [_lastBtn addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_lastBtn];
    //创建循环播放按钮
    _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _circleBtn.frame = CGRectMake(self.view.frame.size.width/2-140, self.view.frame.size.height-45, 40, 40);
    [_circleBtn setBackgroundImage:[UIImage imageNamed:@"circleClose"] forState:UIControlStateNormal];
    [_circleBtn setBackgroundImage:[UIImage imageNamed:@"circleOpen"] forState:UIControlStateSelected];
    [_circleBtn addTarget:self action:@selector(circle) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_circleBtn];
    //创建随机播放按钮
    _randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _randomBtn.frame = CGRectMake(self.view.frame.size.width/2+100, self.view.frame.size.height-45, 40, 40);
    [_randomBtn setBackgroundImage:[UIImage imageNamed:@"randomClose"] forState:UIControlStateNormal];
    [_randomBtn setBackgroundImage:[UIImage imageNamed:@"randomOpen"] forState:UIControlStateSelected];
    [_randomBtn addTarget:self action:@selector(random) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:_randomBtn];
    //创建歌曲列表与歌词显示控件视图
    _contentView = [[MusicContentView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-150)];
    _contentView.titleDataArray = _dataArray;
    _contentView.play = _player;
    [bg addSubview:_contentView];
}

//播放音乐
-(void)playMusic{
    if (_player.isPlaying) {
        _playBtn.selected = NO;
        [_player stop];
    }else{
        _playBtn.selected = YES;
        [_player play];
    }
}

//播放下一首
-(void)next{
    [_player nextMusic];
}

//播放上一首
-(void)last{
    [_player lastMusic];
}

//循环播放
-(void)circle{
    if (_player.isRunLoop) {
        _player.isRunLoop = NO;
        _circleBtn.selected = NO;
    }else{
        _player.isRunLoop = YES;
        _circleBtn.selected = YES;
    }
}

//随机播放
-(void)random{
    if (_player.isRandom) {
        _player.isRandom = NO;
        _randomBtn.selected = NO;
    }else{
        _player.isRandom = YES;
        _randomBtn.selected = YES;
    }
}

//更新UI
-(void)updateUI{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(update) userInfo:nil repeats:YES ];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

//定时器
-(void)update{
    uint64_t locked;
    __block int token = 0;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen", &token, dispatch_get_main_queue(), ^(int t){
        
    });
    notify_get_state(token, &locked);
    //如果设备屏幕关闭，就跳过更新方法、
    if (locked) {
        return;
    }
    _titleLabel = _dataArray[[_player currentIndex]];
    //更新进度条
    if (_player.hadPlayTime != 0) {
        float progress = (float)_player.hadPlayTime/_player.currentSongTime;
        _progresss.progress = progress;
    }
    //更新歌词
    LRCEngine * engine = _player.lrcsArray[_player.currentIndex];
    [engine getCurrentLrcInLRCArray:^(NSArray *lrcArray, int currentIndex) {
        [_contentView setCurrentLRCArray:lrcArray index:currentIndex];
    } atTime:_player.hadPlayTime];
    //更新锁屏界面
    //如果在后台，就再进行更新，否则不更新
    if (!_isBack) {
        return;
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_dataArray[_player.currentIndex] forKey:MPMediaItemPropertyTitle];
    [dict setObject:@"网络歌手" forKey:MPMediaItemPropertyArtist];
    [dict setObject:@"说散就散" forKey:MPMediaItemPropertyAlbumTitle];
    UIImage * newImage = _contentView.lrcImage;
    [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:newImage] forKey:MPMediaItemPropertyArtwork];
    [dict setObject:[NSNumber numberWithDouble:_player.currentSongTime] forKey:MPMediaItemPropertyPlaybackDuration];
    [dict setObject:[NSNumber numberWithDouble:_player.hadPlayTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];//音乐当前已经过时间
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

//切换到后台
-(void)phoneToBack{
    _isBack = YES;
}

//恢复到前台
-(void)phoneToForward{
    _isBack = NO;
}

//播放按钮状态切换
-(void)musicPlayEndAndWillContinuePlaying:(BOOL)play{
    if (play) {
        _playBtn.selected = YES;
    }else{
        _playBtn.selected = NO;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
