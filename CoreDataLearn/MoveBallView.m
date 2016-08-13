//
//  MoveBallView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "MoveBallView.h"

@implementation MoveBallView

- (void)setupView {
    // setup here
    ball = CGRectMake(10, 10, 100, 100);
    velx = 2;
    vely = 2;
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0f / 30.f)
                                     target:self selector:@selector(moveBall)
                                   userInfo:nil repeats:YES];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)moveBall
{
    // animate and redraw
    ball.origin.x += velx;
    ball.origin.y += vely;
    
    if (ball.origin.x < 0) {
        velx *= -1;
        ball.origin.x = 0;
    } else if (ball.origin.x > self.frame.size.width - ball.size.width) {
        velx *= -1;
        ball.origin.x = self.frame.size.width - ball.size.width;
    }
    
    if (ball.origin.y < 0) {
        vely *= -1;
        ball.origin.y = 0;
    } else if (ball.origin.y > self.frame.size.height - ball.size.height) {
        vely *= -1;
        ball.origin.y = self.frame.size.height - ball.size.height;
    }
    
    [self setNeedsDisplay]; // 调用drawRect
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds); // 清理上次留下来的内容
    CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]);
    CGContextFillEllipseInRect(context, ball);
    
    /*
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
     */
    
}

@end
