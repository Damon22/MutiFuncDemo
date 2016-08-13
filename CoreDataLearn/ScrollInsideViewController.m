//
//  ScrollInsideViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/7/7.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ScrollInsideViewController.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

@interface ScrollInsideViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, assign) CGFloat finalUpHeight;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, assign) BOOL isUpper;
@property (nonatomic, assign) BOOL isContentSize;
@property (nonatomic, assign) CGSize tableViewSize;

@end

@implementation ScrollInsideViewController

- (void)viewDidAppear:(BOOL)animated
{
    self.tableViewSize = self.tableView.contentSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.bottomTableView.backgroundColor = [UIColor greenColor];
    self.bottomTableView.estimatedRowHeight = 44.0;
    self.bottomTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    CGRect tableViewFrame = self.tableView.frame;
    self.tabView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewFrame.size.height-30, SCREEN_WIDTH, 30)];
    self.tabView.backgroundColor = [UIColor redColor];
    self.tabView.alpha = 0.5f;
    [self.view addSubview:self.tabView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tabView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.tabView addGestureRecognizer:pan];
    self.finalUpHeight = self.tabView.frame.origin.y;
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"tap");
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    CGRect currentViewFrame = self.tabView.frame;
    CGPoint movePoint = [panGesture translationInView:self.view];
    NSLog(@"movePoint:%@",NSStringFromCGPoint(movePoint));
    
    // 上面tableView
    self.tabView.frame = CGRectMake(0, self.finalUpHeight+movePoint.y, currentViewFrame.size.width, currentViewFrame.size.height);
    self.tableView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+30+movePoint.y);
    
    NSLog(@"tabView.frame:%@",NSStringFromCGRect(self.tabView.frame));
    NSLog(@"tableView.frame:%@",NSStringFromCGRect(self.tableView.frame));
    
    // 下面tableView
    self.bottomTableView.frame = CGRectMake(0, self.finalUpHeight+30+movePoint.y, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-30-movePoint.y);
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        // end
        NSLog(@"end");
        self.finalUpHeight = self.tabView.frame.origin.y;
        // 触及tableView最大contentSize
        if (self.isContentSize && self.tabView.frame.origin.y >= self.tableViewSize.height-30) {
            self.finalUpHeight = self.tableViewSize.height-30;
            self.isContentSize = NO;
        }
        
        if (self.isBottom && self.tabView.frame.origin.y > SCREEN_HEIGHT-30) {
            self.finalUpHeight = SCREEN_HEIGHT-30;
            self.isBottom = NO;
        }
        
        // 上面tableView
        self.tabView.frame = CGRectMake(0, self.finalUpHeight, currentViewFrame.size.width, currentViewFrame.size.height);
        self.tableView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+30);
        
        // 下面tableView
        self.bottomTableView.frame = CGRectMake(0, self.finalUpHeight+30, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-30);
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        // changed
        NSLog(@"changed");
        if (self.tabView.frame.origin.y > SCREEN_HEIGHT-30) {
            self.isBottom = YES;
        }else{
            self.isBottom = NO;
        }
        
        if (self.tabView.frame.origin.y > self.tableViewSize.height-30) {
            self.isContentSize = YES;
        }else{
            self.isContentSize = NO;
        }
        
        
        if (self.isContentSize && self.tabView.frame.origin.y >= self.tableViewSize.height-30) {
            // 上面tableView
            self.finalUpHeight = self.tableViewSize.height-30;
            self.tabView.frame = CGRectMake(0, self.finalUpHeight, currentViewFrame.size.width, currentViewFrame.size.height);
            self.tableView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+30);
            
            // 下面tableView
            self.bottomTableView.frame = CGRectMake(0, self.finalUpHeight+30, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-30);
            
            return;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return 15;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"cell:%ld 您申办的普通护照、往来港澳通行证和签注、往来台湾通行证和签注业务已预约成功。以便查询或取消本次预约。请于2016年02月15日15:00-16:30携带居民身份证和所需的相关证件、材料，提前15分钟前往洛阳市公安局出入境接待大厅(地点：洛阳市洛龙区太康路洛阳市公安局出入境接待大厅)办理业务。",indexPath.row];
    return cell;
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
