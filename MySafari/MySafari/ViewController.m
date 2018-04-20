//
//  ViewController.m
//  MySafari
//
//  Created by Apple on 2018/4/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "HistoryTableViewController.h"
#import "LikeTableViewController.h"

@interface ViewController ()<UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    UIWebView * _webView;
    UITextField * _searchBar;
    BOOL _isUp;
    UILabel * _titleLabel;
    UISwipeGestureRecognizer * _upSwipe;
    UISwipeGestureRecognizer * _downSwipe;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建核心网页视图
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    _isUp = NO;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //默认加载百度
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.baidu.com"]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    //对导航栏进行设置
    [self creatSearchBar];
    //创建手势
    [self creatGesture];
    //创建工具栏
    [self creatToolBar];
    
    //
    NSString * httpUrl = @"http://apis.baidu.com/apistore/dhc/getalltemplate";
    NSString * httpArg = @"user=7f6254b8f81f84709228d6d419d488ac";
    [self requestTest:httpUrl withHttpArg:httpArg];
    
}

//测试NSURLRequest
-(void)requestTest:(NSString * )httpURL withHttpArg:(NSString *)httpArg{
    NSString * urlStr = [[NSString alloc]initWithFormat:@"%@?%@", httpURL, httpArg];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"c925fbc1226c37b905a4d1e2a8cbbe99" forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"Http error: %@%ld", connectionError.localizedDescription, connectionError.code);
        }else{
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString * responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Http Response Code: %ld", responseCode);
            NSLog(@"Http Response Body: %@", responseString);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建导航栏
-(void)creatSearchBar{
    _searchBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 30)];
    _searchBar.borderStyle = UITextBorderStyleRoundedRect;
    UIButton * goBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [goBtn addTarget:self action:@selector(goWeb) forControlEvents:UIControlEventTouchUpInside];
    goBtn.frame = CGRectMake(0, 0, 30, 30);
    [goBtn setTitle:@"GO" forState:UIControlStateNormal];
    _searchBar.rightView = goBtn;
    _searchBar.rightViewMode = UITextFieldViewModeAlways;
    _searchBar.placeholder = @"请输入网址";
    self.navigationItem.titleView = _searchBar;
}

//网页跳转
-(void)goWeb{
    //不为空则打开网页
    if (_searchBar.text.length > 0) {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", _searchBar.text]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    //为空则提示用户
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"输入的网址不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}

//创建手势
-(void)creatGesture{
    //创建回退手势
    _upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipe)];
    _upSwipe.delegate = self;
    _upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [_webView addGestureRecognizer:_upSwipe];
    
    //创建前进手势
    _downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipe)];
    _downSwipe.delegate = self;
    _downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [_webView addGestureRecognizer:_downSwipe];
}

//上滑手势处理逻辑
-(void)upSwipe{
    if (_isUp) {
        return;
    }
    self.navigationItem.titleView = nil;
    _webView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40);
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];
    }completion:^(BOOL finished) {
        //显示调用类属性
        self.navigationItem.titleView = self->_titleLabel;
    }];
    [self.navigationController setToolbarHidden:YES animated:YES];
    _isUp = YES;
}

//下滑手势处理方法
-(void)downSwipe{
    if (_webView.scrollView.contentOffset.y == 0 && _isUp) {
        self.navigationItem.titleView = nil;
        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 64);
            [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
        } completion:^(BOOL finished) {
            self.navigationItem.titleView = self->_searchBar;
        }];
        [self.navigationController setToolbarHidden:NO animated:YES];
        _isUp = NO;
    }
}

//创建工具栏
-(void)creatToolBar{
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem * itemHistory = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(goHistory)];
    UIBarButtonItem * itemLike = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(goLike)];
    UIBarButtonItem * itemBack = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIBarButtonItem * itemForward = [[UIBarButtonItem alloc]initWithTitle:@"forward" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    UIBarButtonItem * emptyItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem * emptyItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem * emptyItem3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.toolbarItems = @[itemHistory, emptyItem1, itemLike, emptyItem2, itemBack, emptyItem3, itemForward];
}

//查看历史记录
-(void)goHistory{
    HistoryTableViewController * controllerHistory = [[HistoryTableViewController alloc]init];
    [self.navigationController pushViewController:controllerHistory animated:YES];
}

//查看我的收藏
-(void)goLike{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择您要进行的操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"添加收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * array = [[NSUserDefaults standardUserDefaults]valueForKey:@"Like"];
        if (!array) {
            array = [[NSArray alloc]init];
        }
        NSMutableArray * newArray = [[NSMutableArray alloc]initWithArray:array];
        [newArray addObject:self->_webView.request.URL.absoluteString];
        [[NSUserDefaults standardUserDefaults]setValue:newArray forKey:@"Like"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"查看收藏夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LikeTableViewController * controller = [[LikeTableViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

//网页返回
-(void)goBack{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

//网页前进
-(void)goForward{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

//加载网页
-(void)loadURL:(NSString *)urlStr{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlStr]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

//当UIWebView加载完成后，将加载的网址通过NSUserDefaults写入本地进行保存
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _titleLabel.text = webView.request.URL.absoluteString;
    NSArray * array = [[NSUserDefaults standardUserDefaults]valueForKey:@"History"];
    if (!array) {
        array = [[NSArray alloc]init];
    }
    NSMutableArray * newArray = [[NSMutableArray alloc]initWithArray:array];
    [newArray addObject:_titleLabel.text];
    [[NSUserDefaults standardUserDefaults]setValue:newArray forKey:@"History"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == _upSwipe || gestureRecognizer == _downSwipe) {
        return YES;
    }
    return NO;
}
















@end
