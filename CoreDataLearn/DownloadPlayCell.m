//
//  DownloadPlayCell.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 2016/9/22.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DownloadPlayCell.h"
#import "CircleProgressButton.h"
#import "TYDownLoadUtility.h"
#import "TYDownloadSessionManager.h"
#import "TYDownLoadDataManager.h"

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

#define COLORWITH(str)      [UIColor colorWithHexString:str]

@interface DownloadPlayCell () <CircleProgressButtonDelegate, TYDownloadDelegate>
@property (nonatomic, strong) TYDownloadModel *taskModel;
@end

@implementation DownloadPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _progressButton = [[CircleProgressButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50), 12, 35, 35) backColor:COLORWITH(@"c3edd9") progressColor:COLORWITH(@"2aab3d") lineWidth:4];
    _progressButton.delegate = self;
    [_progressButton addTarget:self action:@selector(changeStateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [TYDownloadSessionManager manager].delegate = self;
    
    [self.contentView addSubview:_progressButton];
}

-(void)cellWithModel:(TYDownloadModel *)model
{
    _progressButton.selected = YES;
    _taskModel = model;
    self.titleLabel.text = model.fileName;
    //检查之前是否已经下载，若已经下载，则隐藏
    if ([[TYDownloadSessionManager manager] isDownloadCompletedWithDownloadModel:model]) {
        _progressButton.hidden = YES;
        return;
    } else {
        _progressButton.hidden = NO;
        if (_taskModel.state == TYDownloadStateRunning) {
            _progressButton.selected = NO;
            [self startDownload];
        }
    }
    if (!_taskModel.task && [[TYDownloadSessionManager manager] backgroundSessionTasksWithDownloadModel:_taskModel]) {
        [self changeStateAction:nil];
    }
    TYDownloadProgress *progress = [[TYDownLoadDataManager manager]progessWithDownloadModel:model];
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                 [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
    self.sizeLabel.text = fileSizeInUnits;
}

- (void)changeStateAction:(UIButton *)sender
{
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    NSLog(@"before select:%d",sender.selected);
    if (sender.selected) { //将文件状态由暂停改为下载
        if (_taskModel.state == TYDownloadStateCompleted || _taskModel.state == TYDownloadStateFailed) {
            sender.selected = YES;
        } else {
            sender.selected = NO;
        }
        
        // 下载
        [self startDownload];
    } else { //将文件状态由下载改为暂停
        // 暂停下载
        if (_taskModel.state == TYDownloadStateReadying || _taskModel.state == TYDownloadStateRunning) {
            [manager suspendWithDownloadModel:_taskModel];
        }
        sender.selected = YES;
    }
    NSLog(@"%@ after select:%d, _taskModel.state:%lu", _taskModel.fileName,sender.selected,(unsigned long)_taskModel.state);
}

- (void)startDownload
{
    self.progressButton.hidden = NO;
    TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
    __weak typeof(self) weakSelf = self;
    [manager startWithDownloadModel:_taskModel progress:^(TYDownloadProgress *progress) {
        
        weakSelf.progressButton.progress = progress.progress;
        NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                     [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                     [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
        weakSelf.sizeLabel.text = fileSizeInUnits;
        
    } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
        if (state == TYDownloadStateCompleted) {
            weakSelf.progressButton.hidden = YES;
        } else {
            weakSelf.progressButton.hidden = NO;
        }
        
        NSLog(@"state %ld error%@ filePath%@",state,error,filePath);
    }];
}

#pragma mark - TYDownloadDelegate
// 更新下载进度
- (void)downloadModel:(TYDownloadModel *)downloadModel didUpdateProgress:(TYDownloadProgress *)progress
{
    if ([downloadModel isEqual:_taskModel]) {
        if (downloadModel.state == TYDownloadStateReadying || downloadModel.state == TYDownloadStateRunning) {
            self.progressButton.selected = NO;
        } else {
            self.progressButton.selected = YES;
        }
    }
    
    NSLog(@"%@ delegate progress %.3f",downloadModel.fileName ,progress.progress);
}

// 更新下载状态
- (void)downloadModel:(TYDownloadModel *)downloadModel didChangeState:(TYDownloadState)state filePath:(NSString *)filePath error:(NSError *)error
{
    if ([downloadModel isEqual:_taskModel]) {
        if (state == TYDownloadStateCompleted) {
            self.progressButton.hidden = YES;
        } else {
            self.progressButton.hidden = NO;
        }
    }
    
    NSLog(@"%@ delegate state %ld error%@ filePath%@",downloadModel.fileName,state,error,filePath);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
