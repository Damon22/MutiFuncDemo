//
//  UIView+RoundView.m
//  Damon
//
//  Created by Damon on 15/8/24.
//  Copyright (c) 2015年 Damon.Team. All rights reserved.
//

#import "UIView+RoundView.h"

@implementation UIView (RoundView)

/**
 设置圆角
 */
- (void)setCornerRadius:(CGFloat)_cornerRadius
{
    self.layer.cornerRadius     = _cornerRadius;
    self.layer.masksToBounds    = YES;
}
/**
 设置成圆形
 */
- (void)setCornerRadiusRound
{
    self.layer.cornerRadius     = self.frame.size.height/2;
    self.layer.masksToBounds    = YES;
}

/**
 设置圆角与边缘的宽度和边缘的颜色
 */
- (void)setCornerRadius:(CGFloat)_cornerRadius layerWidth:(CGFloat )_layerWidth layerColor:(UIColor *)_layerColor
{
    self.layer.cornerRadius     = _cornerRadius;
    self.layer.masksToBounds    = YES;
    self.layer.borderWidth      = _layerWidth;
    self.layer.borderColor      = _layerColor.CGColor;
}

//画一条线
- (void)setlineFrame:(CGRect)_frame lineColor:(UIColor *)_color lineAlpha:(CGFloat)_alpha;
{
    UIView* lineView            = [[UIView alloc]initWithFrame:_frame];
    lineView.backgroundColor    = _color;
    lineView.alpha              = _alpha;
    [self addSubview:lineView];
}


@end
