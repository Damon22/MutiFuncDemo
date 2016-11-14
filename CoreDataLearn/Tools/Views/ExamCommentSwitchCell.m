//
//  ExamCommentSwitchCell.m
//  WinLesson
//
//  Created by 高继鹏 on 16/7/7.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ExamCommentSwitchCell.h"

@implementation ExamCommentSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.upLine.backgroundColor = COLOR_LINE;
    self.bottomLine.backgroundColor = COLOR_LINE;
    self.midLine.backgroundColor = COLOR_LINE;
    self.upLineHeight.constant = 0.5f;
    self.bottomLineHeight.constant = 0.5f;
    self.midLineWidth.constant = 0.5f;
    
    [self.leftButton setTitleColor:COLOR_FontTintBlack forState:UIControlStateNormal];
    [self.leftButton setTitleColor:NavDefaultColor forState:UIControlStateSelected];
    
    [self.rightButton setTitleColor:COLOR_FontTintBlack forState:UIControlStateNormal];
    [self.rightButton setTitleColor:NavDefaultColor forState:UIControlStateSelected];
    
    self.leftButton.selected = YES;
    
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, cellFrame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
