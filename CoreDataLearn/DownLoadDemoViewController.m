//
//  DownLoadDemoViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/2.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DownLoadDemoViewController.h"
#import "DownloadInfoCell.h"
//#import "FGGDownloadManager.h"
#import "HSDownloadManager.h"
#import "BaseCircleView.h"
#import "TaskModel.h"

#define kCachePath (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])

@interface DownLoadDemoViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray  *_dataArray;
}
@end

@implementation DownLoadDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
//    [self prepareData];
    _dataArray = [NSMutableArray arrayWithArray:self.downloadArr];
}

//添加3个任务模型
- (void)prepareData
{
    _dataArray=[NSMutableArray array];
    TaskModel *model=[TaskModel model];
    model.name=@"GDTSDK.zip";
    model.url=@"http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip";
    model.destinationPath=[kCachePath stringByAppendingPathComponent:model.name];
    model.progress = [[HSDownloadManager sharedInstance] progress:model.url];
    [_dataArray addObject:model];
    
    TaskModel *anotherModel=[TaskModel model];
    anotherModel.name=@"CONTENT.jar";
    anotherModel.url=@"http://android-mirror.bugly.qq.com:8080/eclipse_mirror/juno/content.jar";
    anotherModel.destinationPath=[kCachePath stringByAppendingPathComponent:anotherModel.name];
    anotherModel.progress = [[HSDownloadManager sharedInstance] progress:anotherModel.url];
    [_dataArray addObject:anotherModel];
    
    TaskModel *third=[TaskModel model];
    third.name=@"Dota2";
    third.url=@"http://4402.vod.myqcloud.com/4402_fa11faccf7e311e5a0cbbbca3e6e518c.f20.mp4";
    third.destinationPath=[kCachePath stringByAppendingString:third.name];
    third.progress = [[HSDownloadManager sharedInstance] progress:third.url];
    [_dataArray addObject:third];
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadInfoCell *cell=(DownloadInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"DownloadInfoCell"];
    TaskModel *model=_dataArray[indexPath.row];
    [cell cellWithModel:model];
    //点击下载按钮时回调的代码块
    __weak typeof(cell) weakCell=cell;
    cell.downloadBlock=^(BaseCircleView *currentStatusView){
        if (currentStatusView.circleStatus == DownloadBegin) {
            [[HSDownloadManager sharedInstance] download:model.url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //更新进度条的进度值
                    CGFloat currentProgress = (1.0 * receivedSize / expectedSize);
                    NSLog(@"currentProgress:%.2f,progress:%.2f",currentProgress, progress);
                    [currentStatusView setProgress:progress animated:YES];
                    [currentStatusView setCurrentDownloadStatus:DownloadPause];
                    weakCell.sizeLabel.text = [NSString stringWithFormat:@"%@",[HSDownloadManager convertSize:expectedSize]];
                    model.progress = progress;
                    // weakCell.speedLabel.text = speedString;
                });
            } state:^(DownloadState state) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == DownloadStateFailed ||
                        state == DownloadStateSuspended) {
                        [currentStatusView setCurrentDownloadStatus:DownloadBegin];
                    } else if (state == DownloadStateCompleted) {
                        weakCell.CircleStatusView.hidden = YES;
                        currentStatusView.circleStatus = DownloadStop;
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@下载完成✅",model.name] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        // 下载中
                        [currentStatusView setCurrentDownloadStatus:DownloadPause];
                    }
                });
            }];  
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [currentStatusView setCurrentDownloadStatus:DownloadBegin];
                [[HSDownloadManager sharedInstance] cancleDownloadForUrl:model.url];
            });
        }
        
        /*
         if(currentStatusView.circleStatus == DownloadBegin)
         {
         //添加下载任务
         [[FGGDownloadManager shredManager] downloadWithUrlString:model.url toPath:model.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
         //更新进度条的进度值
         [currentStatusView setProgress:progress animated:YES];
         weakCell.sizeLabel.text = sizeString;
         weakCell.speedLabel.text = speedString;
         
         } completion:^{
         weakCell.CircleStatusView.hidden = YES;
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@下载完成✅",model.name] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
         [alert show];
         
         } failure:^(NSError *error) {
         [[FGGDownloadManager shredManager] cancelDownloadTask:model.url];
         [[FGGDownloadManager shredManager] removeForUrl:model.url file:model.destinationPath];
         currentStatusView.circleStatus = DownloadBegin;
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
         
         }];
         }
         else
         {
         [currentStatusView setCurrentDownloadStatus:DownloadBegin];
         //            [[FGGDownloadManager shredManager] cancelDownloadTask:model.url];
         }*/
    };
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskModel *model=[_dataArray objectAtIndex:indexPath.row];
    [[HSDownloadManager sharedInstance] deleteFile:model.url];
    //    [[FGGDownloadManager shredManager] removeForUrl:model.url file:model.destinationPath];
    [_dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    __weak typeof(self) wkself=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wkself.tableView reloadData];
        });
    });
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"移除";
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
