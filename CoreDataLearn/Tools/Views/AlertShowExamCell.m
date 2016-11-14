//
//  AlertShowExamCell.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "AlertShowExamCell.h"

@implementation AlertShowExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = CLEARCOLOR;
    self.contentView.backgroundColor = CLEARCOLOR;
    self.line.backgroundColor = COLOR_LINE;
    self.midLine.backgroundColor = COLOR_LINE;
    self.lineHeight.constant = 0.8f;
    self.midLineWidth.constant = 0.8f;
    self.infoStrLabel.textAlignment = NSTextAlignmentCenter;
    self.infoStrLabel.textColor = COLOR_FontDeepBlack;
    
    [self.ensureBtn setTitleColor:NavDefaultColor forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:NavDefaultColor forState:UIControlStateNormal];
    NSDictionary *attributeDic = @{CornerRadius:@(8.0),BorderColor:[UIColor whiteColor],BorderWidth:@(0.6)};
    [self.showView RoundedLayerWithAttributeDic:attributeDic];
    
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, 146);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
