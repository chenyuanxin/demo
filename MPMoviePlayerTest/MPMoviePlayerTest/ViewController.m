//
//  ViewController.m
//  MPMoviePlayerTest
//
//  Created by Apple on 2018/5/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
{
    MPMoviePlayerController * _movieController;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //播放视频
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"iphone" ofType:@"mp4"];
//    NSLog(@"path = %@", path);
//    NSURL * url = [NSURL fileURLWithPath:path];
//    _movieController = [[MPMoviePlayerController alloc]initWithContentURL:url];
//    _movieController.view.frame = CGRectMake(0, 0, 320, 300);
//    [self.view addSubview:_movieController.view];
//    [_movieController play];
    
    //查看某一时刻的视频截图
    NSString * path = [[NSBundle mainBundle]pathForResource:@"iphone" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _movieController = [[MPMoviePlayerController alloc]initWithContentURL:url];
    _movieController.controlStyle = MPMovieControlStyleFullscreen;
    _movieController.view.frame = CGRectMake(0, 0, 320, 300);
    [self.view addSubview:_movieController.view];
    UIImage * image = [_movieController thumbnailImageAtTime:100 timeOption:MPMovieTimeOptionNearestKeyFrame];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 350, 320, 200)];
    imageView.image = image;
    [self.view addSubview:imageView];
    [_movieController play];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
