//
//  CustomTBViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/7/8.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "CustomTBViewController.h"
#import "iToast/iToast.h"

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

/** 距离顶部 高度 */
static CGFloat topConstants = 70.0f;
/** 拖动视图 高度 */
static CGFloat dragViewHeight = 30.0f;
/** 距离底部 高度 */
static CGFloat bottomConstants = 44.0f;
/** 默认 上tableView高度 */
static CGFloat originHeight = 270.0f;

@interface CustomTBViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *showTBView;
@property (nonatomic, strong) UITableView *showTBottomView;

@property (nonatomic, strong) UIView *dragView;
@property (nonatomic, assign) CGFloat finalUpHeight;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isContentSize;
@property (nonatomic, assign) CGSize tableViewSize;

@end

@implementation CustomTBViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 调整 上tableView的frame
    self.tableViewSize = self.showTBView.contentSize;
    if (self.tableViewSize.height<originHeight) {
        originHeight = self.tableViewSize.height;
        self.showTBView.frame = CGRectMake(0, 0, SCREEN_WIDTH, originHeight);
        self.showTBottomView.frame = CGRectMake(0, originHeight, SCREEN_WIDTH, SCREEN_HEIGHT-originHeight-64);
        self.dragView.frame = CGRectMake(0, originHeight-dragViewHeight, SCREEN_WIDTH, dragViewHeight);
        self.finalUpHeight = self.dragView.frame.origin.y;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 上面的tableView
    self.showTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, originHeight) style:UITableViewStylePlain];
    self.showTBView.estimatedRowHeight = 50.0;
    self.showTBView.rowHeight = UITableViewAutomaticDimension;
    self.showTBView.backgroundColor = [UIColor yellowColor];
    self.showTBView.bounces = NO;
    self.showTBView.delegate = self;
    self.showTBView.dataSource = self;
    [self.showTBView reloadData];
    [self.view addSubview:self.showTBView];
    
    // 下面的tableView
    self.showTBottomView = [[UITableView alloc] initWithFrame:CGRectMake(0, originHeight, SCREEN_WIDTH, SCREEN_HEIGHT-originHeight-64) style:UITableViewStylePlain];
    self.showTBottomView.estimatedRowHeight = 70.0;
    self.showTBottomView.rowHeight = UITableViewAutomaticDimension;
    self.showTBottomView.backgroundColor = [UIColor greenColor];
    self.showTBottomView.delegate = self;
    self.showTBottomView.dataSource = self;
    self.showTBottomView.showsVerticalScrollIndicator = NO;
    [self.showTBottomView reloadData];
    [self.view addSubview:self.showTBottomView];
    
    // 滑块UI
    self.tableViewSize = self.showTBView.contentSize;
    self.dragView = [[UIView alloc] initWithFrame:CGRectMake(0, originHeight-dragViewHeight, SCREEN_WIDTH, dragViewHeight)];
    self.dragView.backgroundColor = [UIColor redColor];
    self.dragView.alpha = 0.5f;
    [self.view addSubview:self.dragView];
    self.finalUpHeight = self.dragView.frame.origin.y;
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.dragView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.dragView addGestureRecognizer:pan];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"拖动试试");
    
    CGPoint dragPoint = self.dragView.frame.origin;
    if (dragPoint.y >= SCREEN_HEIGHT-bottomConstants-64) {
        // 上面tableView
        self.showTBView.frame = CGRectMake(0, 0, SCREEN_WIDTH, originHeight);
        self.dragView.frame = CGRectMake(0, originHeight-dragViewHeight, SCREEN_WIDTH, dragViewHeight);
        
        // 下面tableView
        self.showTBottomView.frame = CGRectMake(0, originHeight, SCREEN_WIDTH, SCREEN_HEIGHT-originHeight-64);
        self.finalUpHeight = self.dragView.frame.origin.y;
    }else{
        [[iToast makeText:@"拖动试试"] show];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    CGRect currentViewFrame = self.dragView.frame;
    CGPoint movePoint = [panGesture translationInView:self.view];
    NSLog(@"movePoint:%@",NSStringFromCGPoint(movePoint));
    
    if (currentViewFrame.origin.y <= 40 && movePoint.y<0) {
        movePoint = CGPointMake(0, 0);
    }
    
    if (currentViewFrame.origin.y >= self.tableViewSize.height-30 && movePoint.y>0) {
        movePoint = CGPointMake(0, 0);
    }
    
    if (currentViewFrame.origin.y >= SCREEN_HEIGHT-bottomConstants-64 && movePoint.y>0) {
        movePoint = CGPointMake(0, 0);
    }
    
    // 上面tableView
    self.dragView.frame = CGRectMake(0, self.finalUpHeight+movePoint.y, currentViewFrame.size.width, currentViewFrame.size.height);
    self.showTBView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+dragViewHeight+movePoint.y);
    
    NSLog(@"dragView.frame:%@",NSStringFromCGRect(self.dragView.frame));
    NSLog(@"tableView.frame:%@",NSStringFromCGRect(self.showTBView.frame));
    
    // 下面tableView
    self.showTBottomView.frame = CGRectMake(0, self.finalUpHeight+dragViewHeight+movePoint.y, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-dragViewHeight-movePoint.y-64);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        //        self.tableViewSize = self.showTBView.contentSize;
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        // end
        NSLog(@"end");
        self.finalUpHeight = self.dragView.frame.origin.y;
        
        // 触及tableView最大contentSize
        if (self.isContentSize) {
            //        if (self.isContentSize && self.dragView.frame.origin.y >= self.tableViewSize.height-dragViewHeight) {
            self.finalUpHeight = self.tableViewSize.height-dragViewHeight;
            self.isContentSize = NO;
        }
        
        if (self.isBottom) {
            //        if (self.isBottom && self.dragView.frame.origin.y >= SCREEN_HEIGHT-dragViewHeight-64) {
            if (self.tableViewSize.height-dragViewHeight>SCREEN_HEIGHT-bottomConstants-64) {
                self.finalUpHeight = SCREEN_HEIGHT-bottomConstants-64;
            }else{
                self.finalUpHeight = self.tableViewSize.height-dragViewHeight;
            }
            self.isBottom = NO;
        }
        
        if (self.isTop) {
            //        if (self.isTop && self.dragView.frame.origin.y <= topConstants - dragViewHeight) {
            self.finalUpHeight = topConstants - dragViewHeight;
            self.isTop = NO;
        }
        
        // 上面tableView
        self.dragView.frame = CGRectMake(0, self.finalUpHeight, currentViewFrame.size.width, currentViewFrame.size.height);
        self.showTBView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+dragViewHeight);
        
        // 下面tableView
        self.showTBottomView.frame = CGRectMake(0, self.finalUpHeight+dragViewHeight, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-dragViewHeight-64);
        
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        // changed
        NSLog(@"changed");
        // 判断 最底部 距离问题
        if (self.dragView.frame.origin.y > SCREEN_HEIGHT-bottomConstants-64) {
            self.isBottom = YES;
        }else{
            self.isBottom = NO;
        }
        
        // 判断 内容高度问题
        if (self.dragView.frame.origin.y > self.tableViewSize.height-dragViewHeight) {
            self.isContentSize = YES;
        }else{
            self.isContentSize = NO;
        }
        
        // 判断 最高高度问题
        if (self.dragView.frame.origin.y < topConstants) {
            self.isTop = YES;
        }else{
            self.isTop = NO;
        }
        
        if (self.isTop && self.dragView.frame.origin.y <= topConstants - dragViewHeight) {
            // 上面tableView
            self.finalUpHeight = topConstants - dragViewHeight;
            self.dragView.frame = CGRectMake(0, self.finalUpHeight, currentViewFrame.size.width, currentViewFrame.size.height);
            self.showTBView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+dragViewHeight);
            
            // 下面tableView
            self.showTBottomView.frame = CGRectMake(0, self.finalUpHeight+dragViewHeight, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-dragViewHeight-64);
            
            return;
        }
        
        if (self.isContentSize && self.dragView.frame.origin.y >= self.tableViewSize.height-dragViewHeight) {
            // 上面tableView
            self.finalUpHeight = self.tableViewSize.height-dragViewHeight;
            self.dragView.frame = CGRectMake(0, self.finalUpHeight, currentViewFrame.size.width, currentViewFrame.size.height);
            self.showTBView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+dragViewHeight);
            
            // 下面tableView
            self.showTBottomView.frame = CGRectMake(0, self.finalUpHeight+dragViewHeight, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-dragViewHeight-64);
            
            return;
        }
        
        if ((self.isBottom && self.dragView.frame.origin.y > SCREEN_HEIGHT-bottomConstants-64)) {
            // 上面tableView
            self.finalUpHeight = SCREEN_HEIGHT-bottomConstants-64;
            self.dragView.frame = CGRectMake(0, self.finalUpHeight, currentViewFrame.size.width, currentViewFrame.size.height);
            self.showTBView.frame = CGRectMake(0, 0, currentViewFrame.size.width, self.finalUpHeight+dragViewHeight);
            
            // 下面tableView
            self.showTBottomView.frame = CGRectMake(0, self.finalUpHeight+dragViewHeight, currentViewFrame.size.width, SCREEN_HEIGHT - self.finalUpHeight-dragViewHeight-64);
            
            return;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.showTBView]) {
        return 3;
    }
    return 15;
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
    if ([tableView isEqual:self.showTBottomView]) {
        cell.textLabel.text = [NSString stringWithFormat:@"cell:%ld Hello World。",indexPath.row];
    }
    return cell;
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
