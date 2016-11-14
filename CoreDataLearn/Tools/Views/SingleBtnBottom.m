//
//  SingleBtnBottom.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "SingleBtnBottom.h"

@implementation SingleBtnBottom

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = NavDefaultColor;
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, 50);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
