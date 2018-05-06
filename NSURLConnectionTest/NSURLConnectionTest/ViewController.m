//
//  ViewController.m
//  NSURLConnectionTest
//
//  Created by Apple on 2018/4/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
{
    NSMutableData * _data;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     //同步方式
    NSURL * url = [NSURL URLWithString:@"http://apis.baidu.com/apistore/wooyun/unclaim?limit=10"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"c925fbc1226c37b905a4d1e2a8cbbe99" forHTTPHeaderField:@"apikey"];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataStr);
     */
    
    /*
    //异步方式
    NSURL * url = [NSURL URLWithString:@"http://apis.baidu.com/apistore/wooyun/unclaim?limit=10"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"c925fbc1226c37b905a4d1e2a8cbbe99" forHTTPHeaderField:@"apiKey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", dataStr);
    }];
    NSLog(@"异步进行网络请求");
     */
    
    //代理方式处理网络回调
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"c925fbc1226c37b905a4d1e2a8cbbe99" forHTTPHeaderField:@"apikey"];
    NSURLConnection * connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

//当接收到返回数据时会被调用，在其中进行数据容器的初始化
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"开始接收数据");
    //进行数据初始化
    _data = [[NSMutableData alloc]init];
}

//在接收数据过程中会被多次调用，会将接收到的数据传递进来
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
}

//在接收数据完成后被调用，会将接收到的完整数据转化为字符串进行打印操作
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"接收数据完成");
    NSString * dataStr = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的数据内容：%@", dataStr);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
