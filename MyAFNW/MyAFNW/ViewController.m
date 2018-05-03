//
//  ViewController.m
//  MyAFNW
//
//  Created by Apple on 2018/4/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "MyNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [MyNetworking sharedNetWorking].HTTPHeadersDic = @{@"apikey":@"c925fbc1226c37b905a4d1e2a8cbbe99"};
    [MyNetworking getRequestWithURLString:@"http://apis.baidu.com/apistore/iplookup/iplookup_paid?ip=117.89.35.58" finish:^(BOOL success, NSData *data) {
        if (success) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"返回结果：%@", dic);
        }else{
            NSLog(@"返回失败了");
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
