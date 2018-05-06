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
    //http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=秦始皇&bk_length=600
    //http://p.3.cn/prices/mgets?skuIds=J_954086&type=1
    [MyNetworking getRequestWithURLString:@"http://api.map.baidu.com/telematics/v3/weather?location=嘉兴&output=json&ak=5slgyqGDENN7Sy7pw29IUvrZ" finish:^(BOOL success, NSData *data) {
        if (success) {
            NSLog(@"viewDidLoad() 调用成功: %@", data);
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
