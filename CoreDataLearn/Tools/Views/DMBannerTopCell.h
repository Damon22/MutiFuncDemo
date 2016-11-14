//
//  DMBannerTopCell.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/20.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//
// 广告轮播图

#import <UIKit/UIKit.h>

@class WLBannerView;
@interface DMBannerTopCell : UITableViewCell

// cell 高度 : 57.5

/** 底部背景图片 */
@property (weak, nonatomic) IBOutlet UIView *topBGView;
/** 关闭按钮 */
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/** 关闭按钮 右边距: 5 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeBtnRight;

@property (strong, nonatomic) WLBannerView *bannerView;

@property (nonatomic, assign) CGFloat cellHeight;

@end
