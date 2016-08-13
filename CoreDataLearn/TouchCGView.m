//
//  TouchCGView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "TouchCGView.h"

@implementation TouchCGView

- (CGFloat)distance:(CGPoint)p1 ofPoint:(CGPoint)p2
{
    return sqrt(pow((p1.y - p2.y), 2) + pow((p1.x - p2.x), 2));
//    return sqrt(pow(fabs(p1.y - p2.y), 2) + pow(fabs(p1.x - p2.x), 2));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([event.allTouches count] != 2) {
        NSLog(@"Not two fingers.");
        return;
    }
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    int step = 0;
    for (UITouch * t in event.allTouches) {
        // get coordinates
        if (step == 0) {
            p1 = [t locationInView:self];
        } else {
            p2 = [t locationInView:self];
        }
        step = 1;
    }
    diameter = [self distance:p1 ofPoint:p2];
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect circleFrame;
    circleFrame.origin.x = self.frame.size.width / 2 - diameter / 2;
    circleFrame.origin.y = self.frame.size.height / 2 - diameter / 2;
    circleFrame.size.width = diameter;
    circleFrame.size.height = diameter;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]);
    CGContextFillEllipseInRect(context, circleFrame);
}



@end
