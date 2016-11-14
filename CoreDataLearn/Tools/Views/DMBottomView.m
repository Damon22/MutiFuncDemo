//
//  DMBottomView.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/15.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DMBottomView.h"
#import "UIButton+ExecuteOnce.h"

@implementation DMBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置button样式
    self.FuncButton.backgroundColor = NavDefaultColor;
    NSDictionary *attributeDic = @{CornerRadius:@(14.0),BorderColor:NavDefaultColor,BorderWidth:@(0.01)};
    [self.FuncButton RoundedLayerWithAttributeDic:attributeDic];
    
    self.cellHeight = DMBottomDefaultHeight;
    
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, DMBottomDefaultHeight);
}

/** 设置 背景颜色 */
- (void)setBGBackgroundColor:(UIColor *)backgroundColor {
    self.BGContentView.backgroundColor = backgroundColor;
}

/** 设置 按钮文本 */
- (void)setFuncButtonTitle:(NSString *)buttonTitle {
    [self.FuncButton setTitle:buttonTitle forState:UIControlStateNormal];
}

/** 设置 frame */
- (void)setDMBottomViewSize:(CGSize)newSize {
    // 设置frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, newSize.width, newSize.height);
}

/** 设置 透明 默认:NO */
- (void)setBGTranslucent:(BOOL)isTranslucent {
    if (isTranslucent) {
        self.backgroundColor = [UIColor clearColor];
        self.BGContentView.backgroundColor = [UIColor clearColor];
    }
}

/** 设置 顶部距离:默认0 */
- (void)setFuncButtonToUpConstent:(CGFloat)height {
    self.FunButtonToUp.constant = height;
}

/** 支付模式 */
- (void)isPayModel
{
    if (!iPhoneWidthBiggerThan5) {
        [self setFuncButtonToUpConstent:30];
        self.cellHeight = 97;
    }else{
        [self setFuncButtonToUpConstent:140];
        self.cellHeight = 260;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
