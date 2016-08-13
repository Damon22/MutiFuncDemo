//
//  DMLineChartView.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/23.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLineChartView : UIView

/** 表格的x、y轴 段个数 */
@property (nonatomic, copy) NSArray *xAxis;
@property (nonatomic, copy) NSArray *yAxis;

/** 表格的x、y轴 颜色 */
@property (nonatomic, strong) UIColor *xAxisColor;
@property (nonatomic, strong) UIColor *yAxisColor;

/** 表格的y轴 最大、最小 值 */
@property (nonatomic, assign) CGFloat yValueMin;
@property (nonatomic, assign) CGFloat yValueMax;

/** 曲线 颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 曲线 线宽 */
@property (nonatomic) CGFloat lineWidth;

/** 动画 时长 */
@property (nonatomic) CGFloat animationDuration;

/** 文字 颜色 */
@property (nonatomic, strong) UIColor *fontColor;
/** 文字 字体大小 */
@property (nonatomic) CGFloat fontSize;

/** 设置 表格 数据 */
- (void)setChartData:(NSArray *)chartData;

@end
