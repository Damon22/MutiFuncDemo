//
//  DMBottomSelectView.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/16.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DMBottomSelectView.h"

@implementation DMBottomSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.midLine.backgroundColor = [UIColor whiteColor];
    self.leftButton.backgroundColor = NavDefaultColor;
    self.rightButton.backgroundColor = NavDefaultColor;
    self.midLineWidth.constant = 0.5f;
    self.midLineTop.constant = 0.f;
    self.midLineBottom.constant = 0.f;
}

- (void)setLeftButton:(NSString *)Ltitle RightButton:(NSString *)Rtitle
{
    [self.leftButton setTitle:Ltitle forState:UIControlStateNormal];
    [self.rightButton setTitle:Rtitle forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
