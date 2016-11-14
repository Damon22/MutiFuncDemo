//
//  UIView+nice.h
//  必胜课
//
//  Created by Damon on 15/8/24.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (nice)
- (void)RoundedLayerWithCornerRadius:(CGFloat)radius andBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width;

/** 对圆锯齿优化，性能有影响 */
-(void)RoundedBatterLayerWithCornerRadius:(CGFloat)radius andBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width;

//给某些UIView加圆角边框,圆角边框的属性存在attributeDic中
- (void)RoundedLayerWithAttributeDic:(NSDictionary *)attributeDic;

//给lable或textView的内容加行间距
- (void)lineSpacing:(CGFloat)spacing;
@end
