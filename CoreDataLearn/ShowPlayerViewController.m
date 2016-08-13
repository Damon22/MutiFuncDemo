//
//  ShowPlayerViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/23.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ShowPlayerViewController.h"
#import "TableViewController1.h"
#import "TableViewController2.h"
#import "TableViewController3.h"

#import "TCPlayerBottomView.h"

#import "TCPlayerActionHandler.h"

#import "ScreenSizeCount.h"

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

@interface ShowPlayerViewController ()<TCPlayerEngineDelegate, UIScrollViewDelegate>
{
    TCPlayerView *_playerView;
    CGFloat viewHeight;
    UIView *bottomView;
    TableViewController1 *tableVC1;
    TableViewController2 *tableVC2;
    TableViewController3 *tableVC3;
    CGFloat tableViewLast;
    int topORdown;
    
}

@property (nonatomic, strong) UIScrollView *wholeScrollView;
@property (nonatomic, strong) UIView *headView;

@end

@implementation ShowPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    topORdown = 0;
    tableViewLast = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _wholeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _wholeScrollView.backgroundColor = [UIColor whiteColor];
//    _wholeScrollView.showsVerticalScrollIndicator = NO;
//    _wholeScrollView.pagingEnabled = YES;
    _wholeScrollView.delegate = self;
    _wholeScrollView.bounces = NO;
    _wholeScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_wholeScrollView];
    
    viewHeight = [ScreenSizeCount currentViewWidth];
    
    _wholeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+viewHeight);
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight+57)];
    _headView.backgroundColor = [UIColor whiteColor];
    [_wholeScrollView addSubview:_headView];
    
    _playerView = [[TCPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewHeight) controlView:nil bottomView:[TCPlayerBottomView class]];
    _playerView.isCyclePlay = NO;
    _playerView.playerDelegate = self;
    //    _playerView.backgroundColor = [UIColor redColor];
    [_headView addSubview:_playerView];
    
    
    TCPlayItem *item = [[TCPlayItem alloc] init];
    item.type = @"标清";
    item.url = @"";//http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f20.mp4
    [_playerView play:item];
    
    TCPlayerActionHandler *handler = [[TCPlayerActionHandler alloc] init];
    
    __weak ShowPlayerViewController *ws = self;
    handler.enterExitFullScreenBlock = ^(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView) {
        BOOL isInFullScreen = [playerView isFullScreen];
        [[UIApplication sharedApplication] setStatusBarHidden:isInFullScreen withAnimation:UIStatusBarAnimationSlide];
        [ws.navigationController setNavigationBarHidden:isInFullScreen animated:YES];
    };
    
    handler.clickPlaybackViewblock = ^(UIView<TCPlayerAbleView, TCPlayerEngine> *playerView, NSInteger actionType) {
        BOOL isBottomViewShow = [playerView isBottomViewShow];
        [[UIApplication sharedApplication] setStatusBarHidden:isBottomViewShow withAnimation:UIStatusBarAnimationSlide];
        [ws.navigationController setNavigationBarHidden:isBottomViewShow animated:YES];
    };
    
    _playerView.playAction = handler;
    NSArray *titleArr = @[@"课程介绍",@"课程列表",@"评论列表"];
    UIView *barItemView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, SCREEN_WIDTH, 57)];
    barItemView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:barItemView];
    
    CGFloat gap = ((SCREEN_WIDTH - 20)/3.0-60)/2.0;
    for (int i = 0; i<3; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(gap + i*(60+2*gap) + 10, 18, 60, 30);
        [itemBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        itemBtn.tag = 1000+i;
        [itemBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [barItemView addSubview:itemBtn];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [barItemView addSubview:line];
    
    tableVC1 = [[TableViewController1 alloc] init];
    tableVC2 = [[TableViewController2 alloc] init];
    tableVC3 = [[TableViewController3 alloc] init];
    [self addChildViewController:tableVC1];
    [self addChildViewController:tableVC2];
    [self addChildViewController:tableVC3];
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight+57, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView = tableVC1.view;
    bottomView.frame = CGRectMake(0, viewHeight+57, SCREEN_WIDTH, SCREEN_HEIGHT);
    tableVC1.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57+64, 0);
    // 设置滚动条的内边距
    tableVC1.tableView.scrollIndicatorInsets = tableVC1.tableView.contentInset;
    tableVC2.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57+64, 0);
    // 设置滚动条的内边距
    tableVC2.tableView.scrollIndicatorInsets = tableVC1.tableView.contentInset;
    tableVC3.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57+64, 0);
    // 设置滚动条的内边距
    tableVC3.tableView.scrollIndicatorInsets = tableVC1.tableView.contentInset;
    [_wholeScrollView addSubview:bottomView];
    tableVC1.tableView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetNotifiTop:) name:@"ScrollToTopNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetNotifiDown:) name:@"ScrollToDownNotification" object:nil];
    
    
}

- (void)selectBtn:(UIButton *)sender
{
    NSLog(@"actionBtn:%@",sender);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0 && topORdown == -1) {
        scrollView.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableViewNotifi" object:@(1)];
    }else if (scrollView.contentOffset.y == 0 && topORdown == 1) {
        scrollView.scrollEnabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableViewNotifi" object:@(0)];
    }else if (scrollView.contentOffset.y == viewHeight && topORdown == 1) {
        scrollView.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableViewNotifi" object:@(1)];
    }else if (scrollView.contentOffset.y == viewHeight && topORdown == -1) {
        scrollView.scrollEnabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableViewNotifi" object:@(0)];
    }else if (scrollView.contentOffset.y == viewHeight && topORdown == 0) {
        scrollView.scrollEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TableViewNotifi" object:@(1)];
    }
}

- (void)GetNotifiTop:(NSNotification *)notifi
{
    topORdown = 1;
    [self scrollViewDidScroll:_wholeScrollView];
}
- (void)GetNotifiDown:(NSNotification *)notifi
{
    topORdown = -1;
    [self scrollViewDidScroll:_wholeScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
