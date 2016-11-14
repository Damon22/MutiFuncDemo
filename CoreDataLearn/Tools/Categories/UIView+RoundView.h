//
//  UIView+RoundView.h
//  Damon
//
//  Created by Damon on 15/8/24.
//  Copyright (c) 2015年 Damon.Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundView)

/**
 设置圆角
 */
- (void)setCornerRadius:(CGFloat)_cornerRadius;
/**
 设置成圆形
 */
- (void)setCornerRadiusRound;
/**
 设置圆角与边缘的宽度和边缘的颜色
 */
- (void)setCornerRadius:(CGFloat)_cornerRadius layerWidth:(CGFloat )_layerWidth layerColor:(UIColor *)_layerColor;
/**
 画一条线
 */
- (void)setlineFrame:(CGRect)_frame lineColor:(UIColor *)_color lineAlpha:(CGFloat)_alpha;


@end
