//
//  ViewController.m
//  AVPlayerTest
//
//  Created by Apple on 2018/5/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//播放视频
- (IBAction)playMovie:(UIButton *)sender {
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"iphone" ofType:@"mp4"];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"iphone" ofType:@"mp4"];
    NSLog(@"path = %@", path);
    NSURL * url = [NSURL fileURLWithPath:path];
    if (url) {
        NSLog(@"url = %@", url);
    }
    AVPlayerViewController * play = [[AVPlayerViewController alloc]init];
    play.player = [[AVPlayer alloc]initWithURL:url];
    [self presentViewController:play animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
