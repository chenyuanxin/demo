//
//  MusicContentView.m
//  MyPlayer
//
//  Created by Apple on 2018/5/30.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MusicContentView.h"
#import "MyMusicPlayer.h"
#import "LRCItem.h"

@interface MusicContentView()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation MusicContentView
{
    UIScrollView * _scrollView;
    //歌曲列表格视图
    UITableView * _titleTableView;
    //单行显示的歌词显示标签
    UILabel * _lrcLabel;
    //锁屏图片中的歌词标签
    UILabel * _lrcIMGLabel;
    //锁屏图片的背景
    UIImageView * _lrcIMGbg;
    //多行显示的歌词显示标签
    UILabel * _lrcView;
    //多行显示歌词视图的显示行数
    int _lines;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置视图背景为透明色
        self.backgroundColor = [UIColor clearColor];
        //初始化滚动视图
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        //初始化歌曲列表
        _titleTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 0, frame.size.width - 90, frame.size.height - 40) style:UITableViewStylePlain];
        _titleTableView.backgroundColor = [UIColor clearColor];
        _titleTableView.delegate = self;
        _titleTableView.dataSource = self;
        //设置表格视图行间无分割线
        _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_titleTableView];
        //设置滚动视图的可滚动范围
        _scrollView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        //设置滚动视图翻页效果
        _scrollView.pagingEnabled = YES;
        //初始化单行显示的歌词控件
        _lrcLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, frame.size.height - 50, frame.size.width - 40, 50)];
        _lrcLabel.backgroundColor = [UIColor clearColor];
        //设置歌词颜色为白色
        _lrcLabel.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_lrcLabel];
        _lrcLabel.textAlignment = NSTextAlignmentCenter;
        _lrcLabel.numberOfLines = 0;
        //初始化多行显示的歌词控件
        _lrcView = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width+20, 50, frame.size.width-40, frame.size.height-100)];
        //根据屏幕尺寸获得显示行数
        _lines = (int)_lrcView.frame.size.height/21;
        _lrcView.numberOfLines = _lines;
        _lrcView.textAlignment = NSTextAlignmentCenter;
        _lrcView.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_lrcView];
        //初始化锁屏图片上的歌词标签
        _lrcIMGLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
        _lrcIMGLabel.numberOfLines = _lines;
        _lrcIMGLabel.textAlignment = NSTextAlignmentCenter;
        _lrcIMGLabel.textColor = [UIColor whiteColor];
        
    }
    return self;
}

//titleDataArray数据源的赋值
-(void)setTitleDataArray:(NSArray *)titleDataArray{
    _titleDataArray = [NSArray arrayWithArray:titleDataArray];
    [_titleTableView reloadData];
}

//
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //设置分区数为1
    return 1;
}

//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //设置行数为数据源中的数据个数
    return self.titleDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        //设置cell的选中效果为无
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = self.titleDataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //单击歌曲列表中某行后播放相应的歌曲
    [self.play playAtIndex:(int)indexPath.row isPlay:self.play.isPlaying];
}

-(void)setCurrentLRCArray:(NSArray *)array index:(int)index{
    NSString * lineLRC = [(LRCItem *)array[index] lrc];
    //提高性能
    if ([_lrcLabel.text isEqualToString:lineLRC]) {
        return;
    }
    _lrcLabel.text = lineLRC;
    
    //进行参数配置
    NSMutableString * lrcStr = [[NSMutableString alloc]init];
    if (index < _lines/2) {
        //前面用\n补齐
        int offset = (int)_lines/2-index;
        for (int j=0; j<offset; j++) {
            [lrcStr appendFormat:@"\n"];
        }
        for (int j=0; j<_lines-offset; j++) {
            [lrcStr appendFormat:@"%@\n", [(LRCItem *)array[j] lrc]];
        }
    }else if (array.count-1-index < _lines/2){
        //后面用\n补齐
        int offset = (int)_lines/2-(int)(array.count-index-1);
        for (int j=index-(_lines/2); j<array.count; j++) {
            [lrcStr appendFormat:@"\n"];
        }
    }else{
        for (int j=0; j<_lines; j++) {
            [lrcStr appendString:[(LRCItem *)array[index-_lines/2+j] lrc]];
            [lrcStr appendString:@"\n"];
        }
    }
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:lrcStr];
    NSRange range = [lrcStr rangeOfString:[array[index] lrc]];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:range];
    _lrcView.attributedText = attrStr;
    _lrcIMGLabel.attributedText = attrStr;
    //进行截屏
    if (!_lrcIMGbg) {
        _lrcIMGbg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _lrcIMGbg.image = [UIImage imageNamed:@"BG.jpg"];
        [_lrcIMGbg addSubview:_lrcIMGLabel];
    }
    UIGraphicsBeginImageContext(_lrcIMGbg.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_lrcIMGbg.layer renderInContext:context];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lrcImage = [img copy];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
