//
//  DMBannerTopCell.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/20.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DMBannerTopCell.h"
#import "WLBannerView.h"
#import "BannerTool.h"

@interface DMBannerTopCell () <BannerToolDelegate>

@end

@implementation DMBannerTopCell
@synthesize imageView;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellHeight = 57.5;
    
    if (IPad) {
        self.closeBtnRight.constant = 15.f;
    }
    // 重新载入frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, cellFrame.size.height);
    
    [BannerTool shareBannerTool].delegate = self;
}

/** 图片点击回调 */
- (void)bannerCycleScrollView:(WLBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index withModel:(WLBannerModel *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBannerInfoNotice object:model userInfo:nil];
}

- (void)dealloc
{
    imageView.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
