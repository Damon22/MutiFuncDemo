//
//  DownloadPlayViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 2016/9/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DownloadPlayViewController.h"
#import "TYDownloadSessionManager.h"
#import "DownloadPlayCell.h"
#import "BaseCircleView.h"
#import "DirectionMPMoviePlayerViewController.h"

@interface DownloadPlayViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray  *_dataArray;
    DirectionMPMoviePlayerViewController *playerView;
}

@end

@implementation DownloadPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray arrayWithArray:self.downloadArr];
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadPlayCell *cell=(DownloadPlayCell *)[tableView dequeueReusableCellWithIdentifier:@"DownloadPlayCell"];
    TYDownloadModel *model=_dataArray[indexPath.row];
    [cell cellWithModel:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYDownloadModel *model=[_dataArray objectAtIndex:indexPath.row];
    [[TYDownloadSessionManager manager] deleteFileWithDownloadModel:model];
    [_dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    __weak typeof(self) wkself=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wkself.tableView reloadData];
        });
    });
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYDownloadModel *model=_dataArray[indexPath.row];
    NSLog(@"model.Path:%@",model.filePath);
    [self playMovieAtURL:[NSURL URLWithString:[self getCorrectLocalPath:model.filePath]]];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"移除";
}

-(void)playMovieAtURL:(NSURL*)theURL
{
    playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:theURL];
    playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerView];
    [playerView.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:playerView];
}

/** 获取正确的打开路径 */
- (NSString *)getCorrectLocalPath:(NSString *)localPath
{
    NSRange range = [localPath rangeOfString:@"Caches/"];
    NSString *partPath = [localPath substringFromIndex:(range.location+range.length)];
    NSLog(@"partPath:%@",partPath);
    partPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:partPath];
    NSLog(@"partPath:%@",partPath);
    return partPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
