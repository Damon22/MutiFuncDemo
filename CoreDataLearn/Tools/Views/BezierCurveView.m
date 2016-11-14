//
//  BezierCurveView.m
//  ZHIZheXianTu
//
//  Created by 刘志雄 on 16/8/9.
//  Copyright © 2016年 刘志雄. All rights reserved.
//

#import "BezierCurveView.h"

static CGRect myFrame;

//圆弧折线图宏
#define KLEFTMARGIN   58 //坐标轴左边距画布距离 (曲线折线图用到)
#define KRIGHTMARGIN  0  //坐标轴距离画布右边距离
#define KTOPMARGIN    10 //坐标轴距离画布上边距离
#define KBOTTONMARGIN 20 //坐标轴距离画布底边距离
#define KXSPACE   ([UIScreen mainScreen].bounds.size.width - KLEFTMARGIN)/self.XtargetCounts  //X轴索引格间距
#define KYSPACE  self.frame.size.height/6      //Y轴索引格间距


#define OLeftMargin    40
#define ORightMargin   30
#define OTopMargin     20
#define OBottonMargin  30
#define OXSpace ([UIScreen mainScreen].bounds.size.width - OLeftMargin - ORightMargin)/self.XtargetCounts
#define OBarWidth [UIScreen mainScreen].bounds.size.width/32

#define KCOLOR(r,g,b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0] //颜色RGB
// 随机色
#define XYQRandomColor  XYQColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@implementation BezierCurveView

//初始化画布
+(instancetype)initWithFrame:(CGRect)frame{
    
    BezierCurveView *bezierCurveView = [[NSBundle mainBundle]loadNibNamed:@"BezierCurveView" owner:self options:nil].lastObject;
    bezierCurveView.frame = frame;
    
    myFrame = frame;
    
    bezierCurveView.isFake = NO;

    return bezierCurveView;
}


#pragma mark -  画坐标

/**
  * 画弧状折线图坐标轴
  */
-(void)p_drawBrokenXLine:(NSMutableArray *)x_names AndYLine:(NSMutableArray *)y_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.Y轴承
    for (int i = 0; i< y_names.count ; i++) {
        
        CGFloat y = CGRectGetHeight(myFrame)-KBOTTONMARGIN - i*KYSPACE;
        UILabel *yTextLabel = [[UILabel alloc]init];
        [yTextLabel setBounds:CGRectMake(0, 0, 25, 20)];
        [yTextLabel setCenter:CGPointMake(KLEFTMARGIN - 30, y)];
        [yTextLabel setText:y_names[i]];
        [yTextLabel setFont:[UIFont systemFontOfSize:14]];
        [yTextLabel setTextAlignment:NSTextAlignmentCenter];
        [yTextLabel setTextColor:RGB(40, 40, 40)];
        [self addSubview:yTextLabel];
    }
    
    //2.中间线
    for (int i = 0; i < y_names.count; i++) {
        
        CGFloat y = CGRectGetHeight(myFrame)- KBOTTONMARGIN + KYSPACE/2 - i * KYSPACE;
        
        if (i == 0) {
            CGPoint movePoint = CGPointMake(0, y);
            CGPoint addPoint  = CGPointMake(CGRectGetWidth(myFrame), y);
            
            [path moveToPoint:movePoint];
            [path addLineToPoint:addPoint];
        }else{
            
            for (int i = 0; i < CGRectGetWidth(myFrame); i+=2) {
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(i, y, 0.5, 0.5) cornerRadius:0.5];
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.fillColor = [UIColor lightGrayColor].CGColor;
                layer.strokeColor = [UIColor lightGrayColor].CGColor;
                layer.path = path.CGPath;
                layer.lineWidth = 0.5f;
                [self.layer addSublayer:layer];
            }
        }
    }
    
    //3.渲染路径
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = RGB(40, 40, 40).CGColor;
    shapeLayer.fillColor = RGB(40, 40, 40).CGColor;
    shapeLayer.lineWidth = 0.5f;
    [self.layer addSublayer:shapeLayer];
}

/**
 * 画直线折线图
 */

-(void)p_drawStraightLineXLine:(NSArray *)x_names AndYLine:(NSArray *)y_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    int Space = ([UIScreen mainScreen].bounds.size.width - OLeftMargin - ORightMargin)/(self.XtargetCounts-1);
    
    //1.画坐标
    //Y轴直线
    [path  moveToPoint:CGPointMake(OLeftMargin,CGRectGetHeight(myFrame)-OBottonMargin)];
    [path addLineToPoint:CGPointMake(OLeftMargin, OTopMargin)];
    //X轴直线
    [path moveToPoint:CGPointMake(OLeftMargin, CGRectGetHeight(myFrame)-OBottonMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-ORightMargin, CGRectGetHeight(myFrame)-OBottonMargin)];
    
    //2.画坐标格
    
    UIBezierPath *otherPath = [UIBezierPath bezierPath];
    //X轴
    for (int i = 0; i < y_names.count-1; i++) {
        
        CGFloat X = OLeftMargin;
        CGFloat Y = CGRectGetHeight(myFrame) - OBottonMargin - (i+1) * _OYSpace;
        CGPoint movePoint = CGPointMake(X, Y);
        CGPoint addPoint = CGPointMake(CGRectGetWidth(myFrame)-ORightMargin, Y);
        [otherPath moveToPoint:movePoint];
        [otherPath addLineToPoint:addPoint];
    }
    
    //Y轴
    for (int i = 0; i < x_names.count; i++) {
        
        CGFloat X = OLeftMargin + (i+1) * Space;
        CGFloat Y = CGRectGetHeight(myFrame) - OBottonMargin;
        CGPoint movePoint = CGPointMake(X, Y);
        CGPoint addPoint = CGPointMake(X,OTopMargin);
        [otherPath moveToPoint:movePoint];
        [otherPath addLineToPoint:addPoint];
    }
    
   
    //3.添加索引格文字
    //X轴
    for (int i = 0; i<x_names.count; i++) {
        
        CGFloat X = OLeftMargin  + i * Space;
        
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin;
        
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 60, 20)];
        [label setCenter:CGPointMake(X, Y + 15)];
        [label setText:x_names[i]];
        [label setTextColor:RGB(40, 40, 40)];
        [label setFont:[UIFont systemFontOfSize:8 ]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    }
    
    //Y轴
    for (int i = 0; i<y_names.count; i++) {
        
        CGFloat X = OLeftMargin-4;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin - i * _OYSpace;
        
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 40, 20)];
        [label setCenter:CGPointMake(X - 18, Y)];
        [label setText:y_names[i]];
        [label setTextColor:RGB(40, 40, 40)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentRight];
        [self addSubview:label];
    }
    
    //4.渲染路径
    CAShapeLayer *otherLayer = [[CAShapeLayer alloc]init];
    otherLayer.lineWidth = 0.5f;
    otherLayer.path = otherPath.CGPath;
    otherLayer.fillColor = [UIColor lightGrayColor].CGColor;
    otherLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:otherLayer];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 0.5f;
    layer.path = path.CGPath;
    layer.fillColor = RGB(40, 40, 40).CGColor;
    layer.strokeColor = RGB(40, 40, 40).CGColor;
    [self.layer addSublayer:layer];
}

/**
 * 画双柱状图坐标轴
 */
-(void)p_drawDoubleBarXLine:(NSArray *)x_names AndYLine:(NSMutableArray *)y_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat LeftMargin = OLeftMargin;
    if (IPad) {
        LeftMargin = OLeftMargin+10;
    }
    
    //1.Y、X轴直线
    //Y轴直线
    [path  moveToPoint:CGPointMake(LeftMargin,CGRectGetHeight(myFrame)-OBottonMargin)];
    [path addLineToPoint:CGPointMake(LeftMargin, OTopMargin)];
    
    //X轴直线
    [path moveToPoint:CGPointMake(LeftMargin, CGRectGetHeight(myFrame)-OBottonMargin)];
    if (IPad) {
        [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-ORightMargin+10, CGRectGetHeight(myFrame)-OBottonMargin)];
    }else{
        [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-ORightMargin, CGRectGetHeight(myFrame)-OBottonMargin)];
    }
    
    //2.索引格
    //X轴
    for (int i = 0; i < x_names.count; i++) {
        
        CGFloat X = LeftMargin + (i+1) * OXSpace;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin;
        [path moveToPoint:CGPointMake(X, Y)];
        [path addLineToPoint:CGPointMake(X, Y + 2)];
    }
    //Y轴
    for (int i = 0; i < y_names.count; i++) {
        
        CGFloat X = LeftMargin;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin - i * _OYSpace;
        [path moveToPoint:CGPointMake(X, Y)];
        [path addLineToPoint:CGPointMake(X-2, Y )];
    }
    
    //3.添加索引格文字
    //X轴
    for (int i = 0; i<x_names.count; i++) {

        CGFloat X = LeftMargin + OXSpace/2 + i * OXSpace;

        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin;
        
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 60, 20)];
        [label setCenter:CGPointMake(X, Y + 15)];
        [label setText:x_names[i]];
        [label setTextColor:RGB(40, 40, 40)];
        [label setFont:[UIFont systemFontOfSize:8]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    }
    
    //Y轴
    for (int i = 0; i<y_names.count; i++) {
        
        CGFloat X = LeftMargin;
        X = LeftMargin-8;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin - i * _OYSpace;
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 40, 20)];
        [label setCenter:CGPointMake(X - 15, Y)];
        [label setText:y_names[i]];
        [label setTextColor:NavDefaultColor];//RGB(40, 40, 40)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentRight];
        [self addSubview:label];
    }
    
    //4.渲染路径
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.fillColor = RGB(40, 40, 40).CGColor;
    layer.strokeColor = RGB(40, 40, 40).CGColor;
    layer.lineWidth = 0.5f;
    [self.layer addSublayer:layer];
}

/**
 * 画单柱状图坐标轴
 */
-(void)p_drawSingleBarXLine:(NSArray *)x_names AndYLine:(NSMutableArray *)y_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //1.画X轴
    [path moveToPoint:CGPointMake(OLeftMargin,CGRectGetHeight(myFrame)-OBottonMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-ORightMargin, CGRectGetHeight(myFrame)-OBottonMargin)];
    
    //2.索引格
    //X轴
    for (int i = 0; i < x_names.count; i++) {
        
        CGFloat X = OLeftMargin + (i+1) * OXSpace;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin;
        [path moveToPoint:CGPointMake(X, Y)];
        [path addLineToPoint:CGPointMake(X, Y + 2)];
    }
    
    //3.添加索引格文字
    //X轴
    for (int i = 0; i<x_names.count; i++) {
        
        CGFloat X = OLeftMargin + OXSpace/2 + i * OXSpace;
        
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin;
        
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 60, 20)];
        [label setCenter:CGPointMake(X, Y + 15)];
        [label setText:x_names[i]];
        [label setTextColor:RGB(40, 40, 40)];
        [label setFont:[UIFont systemFontOfSize:8]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    }
    
    //Y轴
    for (int i = 0; i<y_names.count; i++) {
        
        CGFloat X = OLeftMargin-8;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin - i * _OYSpace;
        
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 40, 20)];
        [label setCenter:CGPointMake(X - 15, Y)];
        [label setText:y_names[i]];
        [label setTextColor:NavDefaultColor]; //RGB(40, 40, 40)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentRight];
        [self addSubview:label];
    }
    
    //4.添加横线
    for (int i =0; i < y_names.count-1; i++) {
        
        UIBezierPath *lightPath = [UIBezierPath bezierPath];
        CGPoint movePoint = CGPointMake(OLeftMargin, CGRectGetHeight(myFrame)-OBottonMargin - (i+1)*_OYSpace);
        CGPoint addPoint = CGPointMake(CGRectGetWidth(myFrame)-ORightMargin, CGRectGetHeight(myFrame)-OBottonMargin - (i+1)*_OYSpace);
        [lightPath moveToPoint:movePoint];
        [lightPath addLineToPoint:addPoint];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor lightGrayColor].CGColor;
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        layer.lineWidth = 0.5f;
        layer.path = lightPath.CGPath;
        [self.layer addSublayer:layer];
    }
    
    //5.渲染路径
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 0.5f;
    layer.path = path.CGPath;
    layer.fillColor = RGB(40, 40, 40).CGColor;
    layer.strokeColor = RGB(40, 40, 40).CGColor;
    [self.layer addSublayer:layer];
}

#pragma mark -  画图形

//画圆弧折线图
-(void)drawLineChartViewWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names TargetValues:(NSMutableArray *)targetValues{
    
    //1.画坐标轴
    [self p_drawBrokenXLine:x_names AndYLine:y_names];
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i = 0; i<targetValues.count; i++) {
        CGFloat doubleValue = KYSPACE/20 * [targetValues[i]floatValue];
        CGFloat x = KLEFTMARGIN + KXSPACE*(i+1);
        CGFloat y = CGRectGetHeight(myFrame)-KBOTTONMARGIN -doubleValue;
        if (isnan(x) || isinf(x)) {
            x = KLEFTMARGIN;
        }
        if (isnan(y) || isinf(y)) {
            y = CGRectGetHeight(myFrame)-KBOTTONMARGIN;
        }
        CGPoint  point = CGPointMake(x, y);
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 1, 1) cornerRadius:1];
        CAShapeLayer *pointLayer = [[CAShapeLayer alloc]init];
        pointLayer.strokeColor = NavDefaultColor.CGColor;
        pointLayer.fillColor = NavDefaultColor.CGColor;
        pointLayer.path = pointPath.CGPath;
        [self.layer addSublayer:pointLayer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //3.坐标连线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(KLEFTMARGIN, CGRectGetHeight(myFrame)-KBOTTONMARGIN)];
    CGPoint prePoint;

    for (int i = 0; i < allPoints.count; i++) {
        
        if (i == 0) {
            prePoint = [allPoints[0] CGPointValue];
            [linePath addCurveToPoint:prePoint controlPoint1:CGPointMake((prePoint.x-KLEFTMARGIN)/2+KLEFTMARGIN, CGRectGetHeight(myFrame)-KBOTTONMARGIN) controlPoint2:CGPointMake((prePoint.x-KLEFTMARGIN)/2+KLEFTMARGIN, prePoint.y)];
        }else{
            CGPoint nowPoint = [allPoints[i] CGPointValue];
            [linePath addCurveToPoint:nowPoint controlPoint1:CGPointMake((prePoint.x+nowPoint.x)/2, prePoint.y) controlPoint2:CGPointMake((prePoint.x + nowPoint.x)/2, nowPoint.y)];//三次曲线
            prePoint = nowPoint;
        }
    }
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = NavDefaultColor.CGColor;
    lineLayer.lineWidth = 3;
    [self.layer addSublayer:lineLayer];
}

/**
 * 画双直线折线图
 */
-(void)drawStraightLineChartWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names firTargetValues:(NSMutableArray *)firtargetValues secTargetValues:(NSMutableArray *)secTargetVlues{
    
    int Space = ([UIScreen mainScreen].bounds.size.width - OLeftMargin - ORightMargin)/(self.XtargetCounts-1);
    
    //1.画出坐标轴
    [self p_drawStraightLineXLine:x_names AndYLine:y_names];
    
    //2.画出坐标点
    NSMutableArray *firAllPoints = [[NSMutableArray alloc]init];
    NSMutableArray *secAllPoints = [[NSMutableArray alloc]init];
    for (int i = 0; i < firtargetValues.count; i++) {
        CGFloat firX = OLeftMargin + i * Space;
        CGFloat firY = CGRectGetHeight(myFrame) - OBottonMargin - _OYSpace/0.2 * [firtargetValues[i]floatValue];
        CGPoint firPoint = CGPointMake(firX,firY);
        
        UIBezierPath *firPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(firPoint.x , firPoint.y) radius:2.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
        CAShapeLayer *firLayer = [[CAShapeLayer alloc]init];
        firLayer.fillColor = KCOLOR(33, 148, 250).CGColor;
        firLayer.strokeColor = KCOLOR(33, 148, 250).CGColor;
        firLayer.path = firPath.CGPath;
        [self.layer addSublayer:firLayer];
        
        [firAllPoints addObject:[NSValue valueWithCGPoint:firPoint]];
        
        CGFloat secX = OLeftMargin + i * Space;
        CGFloat secY = CGRectGetHeight(myFrame) - OBottonMargin - _OYSpace/0.2 * [secTargetVlues[i] floatValue];
        CGPoint secPoint = CGPointMake(secX, secY);
//        UIBezierPath *secPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(secX - 2.5, secY - 2.5, 5, 5) cornerRadius:2.5];
       UIBezierPath *secPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(secX, secY) radius:2.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        CAShapeLayer *secLayer = [CAShapeLayer layer];
        secLayer.fillColor = KCOLOR(255, 181, 68).CGColor;
        secLayer.strokeColor = KCOLOR(255, 181, 68).CGColor;
        secLayer.path = secPath.CGPath;
        [self.layer addSublayer:secLayer];
        
        [secAllPoints addObject:[NSValue valueWithCGPoint:secPoint]];
    }
    
    //3.对坐标点进行连线
    UIBezierPath *firPath = [UIBezierPath bezierPath];
    UIBezierPath *secPath = [UIBezierPath bezierPath];
    if ([firtargetValues count]>0&&[secTargetVlues count]>0) {
        [firPath moveToPoint:CGPointMake(OLeftMargin, CGRectGetHeight(myFrame)-OBottonMargin - OXSpace/0.2 * [firtargetValues[0]floatValue])];
        [secPath moveToPoint:CGPointMake(OLeftMargin, CGRectGetHeight(myFrame)-OBottonMargin - OXSpace/0.2 * [secTargetVlues[0]floatValue])];
        for (int i = 0; i < firtargetValues.count ; i++) {
            [firPath addLineToPoint:[firAllPoints[i] CGPointValue]];
            [secPath addLineToPoint:[secAllPoints[i] CGPointValue]];
        }
    }
    
    //4.画出图形
    CAShapeLayer *firLayer = [[CAShapeLayer alloc]init];
    firLayer.fillColor = [UIColor clearColor].CGColor;
    firLayer.strokeColor = KCOLOR(33, 148, 250).CGColor;
    firLayer.lineWidth = 1.0f;
    firLayer.path = firPath.CGPath;
    [self.layer addSublayer:firLayer];

    
    CAShapeLayer *secLayer = [[CAShapeLayer alloc]init];
    secLayer.fillColor = [UIColor clearColor].CGColor;
    secLayer.strokeColor = KCOLOR(255, 181, 68).CGColor;
    secLayer.lineWidth = 1.0f;
    secLayer.path = secPath.CGPath;
    [self.layer addSublayer:secLayer];
}

//画双柱状图
-(void)drawDoubleBarChartViewWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names firstTargetValues:(NSMutableArray *)firstTargetValues  secondTargetValus:(NSMutableArray *)secondTargetValus{

    //1.画出坐标轴
    [self p_drawDoubleBarXLine:x_names AndYLine:y_names];
    
    CGFloat LeftMargin = OLeftMargin;
    if (IPad) {
        LeftMargin = OLeftMargin+10;
    }
    
    //2.画出柱状图
    CGFloat space = (OXSpace - (2*OBarWidth+2))/2;
    for (int i = 0; i < firstTargetValues.count; i++) {
        
        //第一个柱状图
        CGFloat firX = LeftMargin + space +i * OXSpace;
        CGFloat firY = CGRectGetHeight(myFrame) - OBottonMargin - 1.0*_OYSpace/_OYDivisor * [firstTargetValues[i]floatValue]-0.5;
        //NSLog(@"firY:%f",1.0*_OYSpace/_OYDivisor * [firstTargetValues[i] floatValue]);
        UIBezierPath *firPath = [UIBezierPath bezierPathWithRect:CGRectMake(firX, firY, OBarWidth, 1.0*_OYSpace/_OYDivisor * [firstTargetValues[i] floatValue])];
        CAShapeLayer *firstLayer = [CAShapeLayer layer];
        firstLayer.path = firPath.CGPath;
        firstLayer.strokeColor = RGB(0, 153, 244).CGColor;
        firstLayer.fillColor = RGB(0, 153, 244).CGColor;
        firstLayer.borderWidth = 2.0;
        [self.layer addSublayer:firstLayer];
        
        //第二个柱状图
        CGFloat secX = LeftMargin + OXSpace - space-OBarWidth + i * OXSpace;
        CGFloat secY = CGRectGetHeight(myFrame) - OBottonMargin - 1.0*_OYSpace/_OYDivisor * [secondTargetValus[i] floatValue]-0.5;
        UIBezierPath *secPath = [UIBezierPath bezierPathWithRect:CGRectMake(secX, secY, OBarWidth, 1.0*_OYSpace/_OYDivisor * [secondTargetValus[i] floatValue])];
        
        CAShapeLayer *secLayer = [[CAShapeLayer alloc]init];
        secLayer.fillColor = RGB(254, 182, 67).CGColor;
        secLayer.strokeColor = RGB(254, 182, 67).CGColor;
        secLayer.path = secPath.CGPath;
        [self.layer addSublayer:secLayer];
    }
}



//画单柱状图
-(void)drawSingleBarChartViewWithX_ValueNames:(NSMutableArray *)x_names AndY_ValueNames:(NSMutableArray *)y_names TargetValues:(NSMutableArray *)targetValues{
    
    //1.画出坐标轴
    [self p_drawSingleBarXLine:x_names AndYLine:y_names];
    
    //2.画出柱状图
    CGFloat space = (OXSpace - OBarWidth)/2;
    for (int i = 0; i < x_names.count; i++) {
        
        CGFloat X = OLeftMargin + space + i * OXSpace;
        CGFloat Y = CGRectGetHeight(myFrame)-OBottonMargin-_OYSpace/20 * [targetValues[i]floatValue]-0.5;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X, Y,OBarWidth,_OYSpace/20 * [targetValues[i]floatValue])];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = RGB(254, 182, 67).CGColor;
        layer.strokeColor = RGB(254, 182, 67).CGColor;
        [self.layer addSublayer:layer];
    }
}

//画饼状图
-(void)drawPieChartViewTargetValues:(NSMutableArray *)targetValues andColors:(NSMutableArray *)colors{
    //1.设置圆点
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat startAngle = 0;
    CGFloat endAngle = 0.0;
    CGFloat radius = 75;
    
    //2.计算总数
    __block CGFloat allValues = 0;
    [targetValues enumerateObjectsUsingBlock:^(NSNumber *targetNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        allValues += [targetNumber floatValue];
    }];
    
    //3.画图
    for (int i = 0; i < targetValues.count; i++) {
        
        //算出角度
        CGFloat targetValue = [targetValues[i] floatValue];
        endAngle = startAngle + targetValue/allValues *2*M_PI;
        
        //BezierPath形成闭合的扇形路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point
                                                            radius:radius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        [path addLineToPoint:point];
        [path closePath];
        
        //4.先渲染
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        UIColor *color = colors[i];
        layer.fillColor = color.CGColor;
        layer.strokeColor = color.CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        
        if (fabs(endAngle - startAngle) < M_PI_4/1.5) {
            
            //圆内点
            CGFloat moveX = point.x + 55 *cos(startAngle + (endAngle - startAngle)/2);
            CGFloat moveY = point.y + 55 *sin(startAngle + (endAngle - startAngle)/2);
            CGPoint movePoint = CGPointMake(moveX, moveY);
            
            UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(moveX, moveY) radius:2 startAngle:0 endAngle:M_PI *2 clockwise:YES];
            [pointPath addLineToPoint:CGPointMake(moveX, moveY)];
            [pointPath closePath];
            
            CAShapeLayer *pointLayer = [[CAShapeLayer alloc]init];
            pointLayer.strokeColor = [UIColor whiteColor].CGColor;
            pointLayer.fillColor = [UIColor whiteColor].CGColor;
            pointLayer.path = pointPath.CGPath;
            [self.layer addSublayer:pointLayer];
            
            //于圆外点连线
            CGFloat addX = point.x  + 90 *cos(startAngle + (endAngle - startAngle)/2);
            CGFloat addY = point.y  + 90 *sin(startAngle + (endAngle - startAngle)/2);
            CGPoint addPoint = CGPointMake(addX, addY);
            
            UIBezierPath *linePath = [UIBezierPath bezierPath];
            [linePath moveToPoint:movePoint];
            [linePath addLineToPoint:addPoint];
            
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.fillColor = [UIColor lightGrayColor].CGColor;
            lineLayer.strokeColor = [UIColor blackColor].CGColor;
            lineLayer.path = linePath.CGPath;
            [self.layer addSublayer:lineLayer];
            
            //添加文本
            CGFloat labelX = point.x  + 110 *cos(startAngle + (endAngle - startAngle)/2);
            CGFloat labelY = point.y  + 110 *sin(startAngle + (endAngle - startAngle)/2);
            UILabel *label = [[UILabel alloc]init];
            [label setBounds:CGRectMake(0, 0, 40, 20)];
            if (labelX<0) {
                [label setCenter:CGPointMake(labelX, labelY-5)];
                [label setTextAlignment:NSTextAlignmentRight];
            } else {
                [label setCenter:CGPointMake(labelX, labelY)];
                [label setTextAlignment:NSTextAlignmentCenter];
            }
            
            [label setText:[NSString stringWithFormat:@"%.0f%%",targetValue/allValues*100.0]];
            [label setFont:[UIFont systemFontOfSize:12]];
            [label setTextColor:colors[i]];
            [self addSubview:label];
        }else{
            //5.添加文本
            CGFloat X = point.x + 50 *cos(startAngle + (endAngle-startAngle)/2) - 22.5;
            CGFloat Y = point.y + 50 *sin(startAngle +(endAngle -startAngle)/2) - 10;
            
            if (isnan(X) || isinf(X)) {
                X = 0.0f;
            }
            if (isnan(Y) || isinf(Y)) {
                Y = 0.0f;
            }
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 45, 20)];
            if ([targetValues count]==1&&_isFake) {
                targetValue = 0.f;
            }
            label.text = [NSString stringWithFormat:@"%.0f%%",targetValue/allValues*100.0];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
        startAngle = endAngle;
    }
}

-(void)drawDiscChartViewWithX_names:(NSMutableArray *)x_names andY_names:(NSMutableArray *)y_names andColro:(NSMutableArray *)colors{
    
    //1.设置圆点
    CGPoint point = CGPointMake(self.frame.size.width/2+40, self.frame.size.height/2);
    CGFloat startRaidus = 25;
    CGFloat spaceRadius = 9;
    CGFloat spaceX = 20;
    CGFloat ajuctCount = 20;
    
    if ([x_names count]==1) {
        spaceRadius = 45;
    }
    
    //2.画圆
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:point radius:startRaidus startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [roundPath closePath];
    
    CAShapeLayer *roundLayer = [CAShapeLayer layer];
    roundLayer.fillColor = KCOLOR(221, 220, 225).CGColor;
    roundLayer.strokeColor = [UIColor clearColor].CGColor;
    roundLayer.path = roundPath.CGPath;
    [self.layer addSublayer:roundLayer];
    
    //3.添加文本
    UILabel *label = [[UILabel alloc]init];
    [label setBounds:CGRectMake(0, 0, 40, 20)];
    [label setCenter:point];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"准确率"];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label];
    
    //4.按照数据画内部图形
    for (int i = 0;i < x_names.count; i++) {
        
        CGFloat x = [x_names[i] floatValue];
        CGFloat y = [y_names[i] floatValue];
        CGFloat endAngle = x/y * 2 *M_PI;
        UIBezierPath *colorPath = [UIBezierPath bezierPathWithArcCenter:point radius:startRaidus + spaceRadius/2 + i * (1.5+spaceRadius) startAngle:0 endAngle:endAngle clockwise:YES];
        
        CAShapeLayer *colorLayer = [CAShapeLayer layer];
        colorLayer.fillColor = [UIColor clearColor].CGColor;
        UIColor *color = colors[i];
        colorLayer.strokeColor = color.CGColor;
        colorLayer.path = colorPath.CGPath;
        colorLayer.lineWidth = spaceRadius;
        [self.layer addSublayer:colorLayer];
        
        UIBezierPath *lightPath = [UIBezierPath bezierPathWithArcCenter:point radius:startRaidus + spaceRadius/2 + i * (1.5 + spaceRadius) startAngle:endAngle endAngle:2*M_PI clockwise:YES];
        
        CAShapeLayer *lightLayer = [CAShapeLayer layer];
        lightLayer.fillColor = [UIColor clearColor].CGColor;
        lightLayer.strokeColor = KCOLOR(213, 212, 217).CGColor;
        lightLayer.path = lightPath.CGPath;
        lightLayer.lineWidth = spaceRadius;
        [self.layer addSublayer:lightLayer];
    }
    
    //5.画点连线以及文本描述
    for (int i = 0; i < x_names.count; i++) {
        
        //画圆点
        CGFloat sin;
        CGFloat cos;
        sin = (-ajuctCount + i * spaceX)/(startRaidus + i*1.5 + spaceRadius/2 + i * spaceRadius);
        cos = sqrt(1 - sin * sin);
        CGFloat sinx = (startRaidus + i*1.5 + spaceRadius/2 + i * spaceRadius) * cos;
        
        CGFloat X = point.x - sinx;
        CGFloat Y = point.y - i * spaceX + ajuctCount;
        UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(X, Y) radius:1.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        CAShapeLayer * pointLayer = [CAShapeLayer layer];
        pointLayer.fillColor = [UIColor whiteColor].CGColor;
        pointLayer.strokeColor = [UIColor whiteColor].CGColor;
        pointLayer.path = pointPath.CGPath;
        [self.layer addSublayer:pointLayer];
        
        //画直线
        UIBezierPath *straightPath = [UIBezierPath bezierPath];
        [straightPath moveToPoint:CGPointMake(X, Y)];
        
        CGFloat endX = x_names.count * spaceRadius;
        if (IPad) {
            endX = SCREEN_WIDTH/2.0-SCREEN_WIDTH/5.0;
        } else {
            if (IPHONE_Small6) {
                endX = (x_names.count+1) * spaceRadius;
            } else {
                if (!_isFake) {
                    endX = (x_names.count+3) * spaceRadius;
                } else {
                    endX = spaceRadius*2;
                }
            }
        }
        [straightPath addLineToPoint:CGPointMake(endX, Y)];
        
        CAShapeLayer *straightLayer = [CAShapeLayer layer];
        UIColor *color = colors[i];
        straightLayer.fillColor = color.CGColor;
        straightLayer.strokeColor = color.CGColor;
        straightLayer.path = straightPath.CGPath;
        [self.layer addSublayer:straightLayer];
        
        //6.添加文本
        UILabel *label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 60, 20)];
        if (IPad) {
            [label setCenter:CGPointMake(endX-25, Y)];
        } else {
            if (IPHONE_Small6) {
                if (!_isFake) {
                    [label setCenter:CGPointMake(33, Y)];
                } else {
                    [label setCenter:CGPointMake(40, Y)];
                }
            } else {
                [label setCenter:CGPointMake(endX-20, Y)];
            }
        }
        
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[UIFont systemFontOfSize:10]];
        CGFloat percent = [x_names[i]floatValue]/[y_names[i]floatValue];
        if ([x_names count] == 1 && _isFake) {
            percent = 0;
        }
        [label setText:[NSString stringWithFormat:@"准确率%.0f%%",percent*100.0]];
        [self addSubview:label];
    }
}

@end
