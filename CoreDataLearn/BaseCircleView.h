//
//  BaseCircleView.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLORWITH(str)      [UIColor colorWithHexString:str]

typedef NS_ENUM(NSInteger, DownloadStatus) {
    DownloadBegin,
    DownloadPause,
    DownloadStop
};

@interface BaseCircleView : UIView

/** 当前状态: 停止、开始 */
@property (nonatomic, assign) DownloadStatus circleStatus;

/** 设置圆弧背景色 */
@property (nonatomic, strong) UIColor *lineTintColor;

/** 设置圆弧前景色 */
@property (nonatomic, strong) UIColor *lineUpColor;

/** 设置进度 */
@property (nonatomic, assign) CGFloat progress;

/** 设置线宽 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 设置是否显示 开始、停止 图片 */
@property (nonatomic, assign) BOOL showStatusPic;

/**
 *  @brief 设置进度
 *
 *  @param progress 进度 取值0-1
 *
 *  @param animated 是否显示动画
 *
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/** 
 设置当前状态
 */
- (void)setCurrentDownloadStatus:(DownloadStatus)currentStatus;

@end
