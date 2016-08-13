//
//  TableViewController1.m
//  TableViewDemo
//
//  Created by 高继鹏 on 16/6/23.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "TableViewController1.h"

@interface TableViewController1 ()

@end

@implementation TableViewController1
{
    BOOL canScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    canScroll = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTableViewScroll:) name:@"TableViewNotifi" object:nil];
    self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个我最喜欢的文章",indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)handleTableViewScroll:(NSNotification *)notifi
{
    NSLog(@"notifi:%@",notifi);
    canScroll = [[notifi object] boolValue];
    if (canScroll) {
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToDownNotification" object:scrollView];
        
    }else if (scrollView.contentOffset.y>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToTopNotification" object:scrollView];
    }
    
}

@end
