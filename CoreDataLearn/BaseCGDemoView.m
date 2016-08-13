//
//  BaseCGDemoView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "BaseCGDemoView.h"

@implementation BaseCGDemoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 设置颜色
    CGColorRef yellow = [[UIColor yellowColor] CGColor];
    CGColorRef red = [[UIColor redColor] CGColor];
    CGColorRef blue = [[UIColor blueColor] CGColor];
    
    // 设置内容上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    //---------------------------------/
    // 矩形
    CGContextSetFillColorWithColor(context, yellow);
    CGContextFillRect(context, CGRectMake(10, 70, 100, 100));
    
    //---------------------------------/
    // 椭圆、圆
    CGContextSetFillColorWithColor(context, red);
    CGContextFillEllipseInRect(context, CGRectMake(130, 200, 120, 120));
    
    //---------------------------------/
    // 三角形
    CGContextBeginPath(context);
    // 画点
    CGContextMoveToPoint(context, 150, 110);
    CGContextAddLineToPoint(context, 200, 110);
    CGContextAddLineToPoint(context, 200, 160);
    // 封闭的
    CGContextClosePath(context);
    // 给三角形的path填充颜色
    CGContextSetFillColorWithColor(context, blue);
    CGContextFillPath(context);
    
    //---------------------------------/
    // 曲线（没有结束 ）
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 10, 300);
    CGContextAddLineToPoint(context, 120, 400);
    CGContextAddLineToPoint(context, 300, 200);
    // 填充路径 没有封闭的
    CGContextSetStrokeColorWithColor(context, yellow);
    CGContextStrokePath(context);
}


@end
