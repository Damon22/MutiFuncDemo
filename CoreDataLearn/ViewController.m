//
//  ViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/5/6.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataViewController.h"
#import "PDFTableViewController.h"
#import "TableViewTreeController.h"
#import "FlipViewController.h"
#import "PickViewController.h"
#import "ShowPlayerViewController.h"
#import "PractiseViewController.h"
#import "ScrollInsideViewController.h"
#import "CustomTBViewController.h"
#import "TestDataViewController.h"
#import "UIKitDemoViewController.h"
#import "DownLoadDemoViewController.h"
#import "DownloadPlayViewController.h"
#import "HSDownloadManager.h"
#import "TYDownloadModel.h"
#import "TaskModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableSource;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *downloadArr;

@end

@implementation ViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        _tableView = [[UITableView alloc] initWithFrame:screenFrame style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)tableSource
{
    if (!_tableSource) {
        _tableSource = [NSArray array];
    }
    return _tableSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableSource = @[@"CoreData",@"PDF",@"TableViewTree",@"FlipView",@"PickView",@"PlayerVC",@"PractiseView",@"ScrollView",@"CustomScrollView",@"testData",@"UIKitDemo",@"DownloadDemo",@"DownloadPlayDemo"];
    
    [self prepareData];
    [self prepareDownloadPlayData];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.tableSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableSource.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=self.tableSource.count) {
        return;
    }
    UIViewController *tempVC = nil;
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CoreDataViewController *coreDataVc = [main instantiateViewControllerWithIdentifier:@"CoreDataViewController"];
    PDFTableViewController *pdfVc = [main instantiateViewControllerWithIdentifier:@"PDFTableViewController"];
    TableViewTreeController *treeVc = [main instantiateViewControllerWithIdentifier:@"TableViewTreeController"];
    FlipViewController *flipVc = [[FlipViewController alloc] init];
    PickViewController *pickVc = [[PickViewController alloc] init];
    ShowPlayerViewController *playVc = [[ShowPlayerViewController alloc] init];
    PractiseViewController *practiseVc = [[PractiseViewController alloc] init];
    ScrollInsideViewController *scrollInsideVC = [main instantiateViewControllerWithIdentifier:@"ScrollInsideViewController"];
    CustomTBViewController *customVc = [[CustomTBViewController alloc] init];
    TestDataViewController *testDataVc = [[TestDataViewController alloc] init];
    UIKitDemoViewController *uiKitDemo = [[UIKitDemoViewController alloc] init];
    DownLoadDemoViewController *downloadVc = [main instantiateViewControllerWithIdentifier:@"DownLoadDemoViewController"];
    downloadVc.downloadArr = self.dataArray;
    DownloadPlayViewController *downloadPlayVc = [main instantiateViewControllerWithIdentifier:@"DownloadPlayViewController"];
    downloadPlayVc.downloadArr = self.downloadArr;
    
    if (indexPath.row == 0) {
        tempVC = coreDataVc;
    }else if (indexPath.row == 1) {
        tempVC = pdfVc;
    }else if (indexPath.row == 2) {
        tempVC = treeVc;
    }else if (indexPath.row == 3) {
        tempVC = flipVc;
    }else if (indexPath.row == 4) {
        tempVC = pickVc;
    }else if (indexPath.row == 5) {
        tempVC = playVc;
    }else if (indexPath.row == 6) {
        tempVC = practiseVc;
    }else if (indexPath.row == 7) {
        tempVC = scrollInsideVC;
    }else if (indexPath.row == 8) {
        tempVC = customVc;
    }else if (indexPath.row == 9) {
        tempVC = testDataVc;
    }else if (indexPath.row == 10) {
        tempVC = uiKitDemo;
    }else if (indexPath.row == 11) {
        tempVC = downloadVc;
    }else if (indexPath.row == 12) {
        tempVC = downloadPlayVc;
    }
    [self.navigationController pushViewController:tempVC animated:YES];
}

//添加3个任务模型
- (void)prepareData
{
    _dataArray=[NSMutableArray array];
    TaskModel *model=[TaskModel model];
    model.name=@"GDTSDK.zip";
    model.url=@"http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip";
//    model.destinationPath=[kCachePath stringByAppendingPathComponent:model.name];
    model.progress = [[HSDownloadManager sharedInstance] progress:model.url];
    [_dataArray addObject:model];
    
    TaskModel *anotherModel=[TaskModel model];
    anotherModel.name=@"CONTENT.jar";
    anotherModel.url=@"http://android-mirror.bugly.qq.com:8080/eclipse_mirror/juno/content.jar";
//    anotherModel.destinationPath=[kCachePath stringByAppendingPathComponent:anotherModel.name];
    anotherModel.progress = [[HSDownloadManager sharedInstance] progress:anotherModel.url];
    [_dataArray addObject:anotherModel];
    
    TaskModel *third=[TaskModel model];
    third.name=@"Dota2";
    third.url=@"http://4402.vod.myqcloud.com/4402_fa11faccf7e311e5a0cbbbca3e6e518c.f20.mp4";
//    third.destinationPath=[kCachePath stringByAppendingString:third.name];
    third.progress = [[HSDownloadManager sharedInstance] progress:third.url];
    [_dataArray addObject:third];
}

- (void)prepareDownloadPlayData
{
    _downloadArr = [NSMutableArray array];
    NSString *downloadUrl = @"http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip";
    TYDownloadModel *model = [[TYDownloadModel alloc] initWithURLString:downloadUrl];
    [_downloadArr addObject:model];
    
    
    NSString *downloadUrl1 = @"http://android-mirror.bugly.qq.com:8080/eclipse_mirror/juno/content.jar";
    TYDownloadModel *anotherModel = [[TYDownloadModel alloc] initWithURLString:downloadUrl1];
    [_downloadArr addObject:anotherModel];
    
    
    NSString *downloadUrl2 = @"http://4402.vod.myqcloud.com/4402_fa11faccf7e311e5a0cbbbca3e6e518c.f20.mp4";
    TYDownloadModel *third = [[TYDownloadModel alloc] initWithURLString:downloadUrl2];
    [_downloadArr addObject:third];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
