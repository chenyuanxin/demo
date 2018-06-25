//
//  AppDelegate.h
//  MyPlayer
//
//  Created by Apple on 2018/5/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMusicPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong)MyMusicPlayer *play;
@property (strong, nonatomic) UIWindow *window;


@end

