//
//  ViewController.m
//  MPMoviePlayerViewControllerTest
//
//  Created by Apple on 2018/5/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//播放视频
- (IBAction)playMovie:(UIButton *)sender {
    NSString * path = [[NSBundle mainBundle]pathForResource:@"iphone" ofType:@"mp4"];
    NSURL * url = [NSURL fileURLWithPath:path];
    MPMoviePlayerViewController * controller = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:controller];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
