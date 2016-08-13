
//  DownloadInfoCell.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

// 缓存主目录
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"]

// 保存文件名
#define HSFileName(url) url.md5String

// 文件的存放路径（caches）
#define HSFileFullpath(url) [HSCachesDirectory stringByAppendingPathComponent:HSFileName(url)]

// 文件的已下载长度
#define HSDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:HSFileFullpath(url) error:nil][NSFileSize] integerValue]

#import "DownloadInfoCell.h"
#import "NSString+Hash.h"
#import "FGGDownloadManager.h"
#import "BaseCircleView.h"
#import "HSDownloadManager.h"
#import "TaskModel.h"

@implementation DownloadInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeStatus:)];
    [self.CircleStatusView addGestureRecognizer:tap];
    [self.CircleStatusView setCurrentDownloadStatus:DownloadBegin];
}

- (void)changeStatus:(UITapGestureRecognizer *)gesture
{
    if (self.downloadBlock) {
        self.downloadBlock(self.CircleStatusView);
    }
}

-(void)cellWithModel:(TaskModel *)model
{
    self.titleLabel.text = model.name;
    //检查之前是否已经下载，若已经下载，获取下载进度。
    BOOL exist=[[NSFileManager defaultManager] fileExistsAtPath:HSCachesDirectory];
    CGFloat downloadProgress = 0.0;
    if(exist && HSFileFullpath(model.url))
    {
        //获取原来的下载进度
//        downloadProgress = [[FGGDownloadManager shredManager] lastProgress:model.url];
        downloadProgress = [[HSDownloadManager sharedInstance] progress:model.url];

        //获取原来的文件已下载部分大小及文件总大小
//        _sizeLabel.text=[[FGGDownloadManager shredManager] filesSize:model.url];
        _sizeLabel.text = [NSString stringWithFormat:@"%@",[HSDownloadManager convertSize:[[HSDownloadManager sharedInstance] fileTotalLength:model.url]]];
        if (downloadProgress == 1.0) {
            self.CircleStatusView.hidden = YES;
        } else {
            //原来的进度
            [self.CircleStatusView setProgress:downloadProgress];
        }
        
    }else{
        //原来的进度
        [self.CircleStatusView setProgress:0.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
