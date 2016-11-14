//
//  BezierCurveView.h
//  ZHIZheXianTu
//
//  Created by 刘志雄 on 16/8/9.
//  Copyright © 2016年 刘志雄. All rights reserved.
//

#import <UIKit/UIKit.h>

//线条类型
typedef NS_ENUM(NSInteger , LineType){
    LineTypeStraight, //直线
    LineTypeCurve     //曲线
};

@interface BezierCurveView : UIView

@property (nonatomic,assign)NSInteger XtargetCounts;
@property (nonatomic,assign)NSInteger YtargetCounts;
@property (nonatomic,assign)NSInteger OYSpace;
@property (nonatomic,assign)NSInteger OYDivisor;
@property (nonatomic,assign)BOOL isFake; // 数据是假的，当没有任何数据的时候

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame;

//画圆弧折线图
-(void)drawLineChartViewWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names TargetValues:(NSMutableArray *)targetValues;

//画双直线折线图
-(void)drawStraightLineChartWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names firTargetValues:(NSMutableArray *)firtargetValues secTargetValues:(NSMutableArray *)secTargetVlues;

//画单柱状图
-(void)drawSingleBarChartViewWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names TargetValues:(NSMutableArray *)targetValues;

//画双柱状图
-(void)drawDoubleBarChartViewWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names firstTargetValues:(NSMutableArray *)firstTargetValues  secondTargetValus:(NSMutableArray *)secondTargetValus;

//画饼状图
-(void)drawPieChartViewTargetValues:(NSMutableArray *)targetValues andColors:(NSMutableArray *)colors;

-(void)drawDiscChartViewWithX_names:(NSMutableArray *)x_names andY_names:(NSMutableArray *)y_names andColro:(NSMutableArray *)colors;

@end
