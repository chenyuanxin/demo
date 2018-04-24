//
//  ViewController.m
//  MyRequestConnect
//
//  Created by Apple on 2018/4/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "MyRequestManager.h"
#import "RootDataModel.h"

@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MyRequestManager * manager = [MyRequestManager shareManager];
    manager.HTTPHeadersDic = @{@"apikey":@"c925fbc1226c37b905a4d1e2a8cbbe99"};
    [manager addRequestToManager:@"http://apis.baidu.com/apistore/iplookup/iplookup_paid?ip=117.89.35.58" finished:^(BOOL success, NSData *data) {
        if (success) {
            NSError * error;
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"Json格式：%@, %@", dataDic, error);
            
            NSDictionary * errNumDic = dataDic[@"errNum"];
            NSDictionary * errMsgDic = dataDic[@"errMsg"];
            NSLog(@"errNumDic = %@", errNumDic);
            NSLog(@"errMsg = %@", errMsgDic);
            
            RootDataModel * rootData = [[RootDataModel alloc]init];
            rootData.errNum = [dataDic[@"errNum"] integerValue];
            rootData.errMsg = [dataDic objectForKey:@"errMsg"];
            NSLog(@"rootData.errMsg = %@", rootData.errMsg);
            NSLog(@"rootData = %ld", rootData.errNum);
            
            NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"返回的数据：%@", dataStr);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
