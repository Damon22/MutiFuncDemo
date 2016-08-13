//
//  TableViewTreeController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/7.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "TableViewTreeController.h"

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

@interface TableViewTreeController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableViewSource;

@end

@implementation TableViewTreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewSource = [NSMutableArray arrayWithArray:@[@[],@[@"",@"",@""],@[@"",@""],@[@"",@"",@"",@""],@[@""]]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableViewSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld,row:%ld",(long)self.tableViewSource[indexPath.section],(long)self.tableViewSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor orangeColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
    titleLabel.text = [NSString stringWithFormat:@"section:%ld",section];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [sectionView addSubview:titleLabel];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 15, 60, 30)];
    [rightBtn setTitle:@"sectionBtn" forState:UIControlStateNormal];
    rightBtn.tag = section+1000;
    [rightBtn addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:rightBtn];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (void)sectionAction:(UIButton *)sender
{
    NSLog(@"sender.tag:%ld",sender.tag);
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
