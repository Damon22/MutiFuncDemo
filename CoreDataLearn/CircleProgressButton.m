//
//  CircleProgressButton.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/9/12.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "CircleProgressButton.h"

@interface CircleProgressButton ()

@property (assign, nonatomic) CGFloat angle;

@end

@implementation CircleProgressButton

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        //        UIImage *imgPause = [[UIImage alloc]initWithContentsOfFile:[[NSBundle alloc]pathForResource:@"file_pause_normal" ofType:@"png"]];
        //  UIImage *imgPause =[[UIImage alloc]initWithContentsOfFile:[[NSBundle alloc]pathForResource:@"file_pause_normal" ofType:@"png"]];
        
        //  [UIImage imageNamed:@"file_pause_normal.png"];
        //  UIImage *imgDown =
        //  [[UIImage alloc]initWithContentsOfFile:[[NSBundle alloc]pathForResource:@"file_download_normal" ofType:@"png"]];
        UIImage *imgPause = [UIImage imageNamed:@"下载01"];
        UIImage *imgDown =[UIImage imageNamed:@"暂停下载01"];
        [self setBackgroundImage:imgPause forState:UIControlStateNormal];
        [self setBackgroundImage:imgDown  forState:UIControlStateSelected];
        _progressColor = progressColor;
        _lineWidth = lineWidth;
        _backColor = backColor;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateProgressViewWithProgress:)]) {
        [self.delegate updateProgressViewWithProgress:self.progress];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2)
                                                              radius:(CGRectGetWidth(self.bounds) - self.lineWidth ) / 2
                                                          startAngle:(CGFloat) - M_PI_2
                                                            endAngle:(CGFloat)(1.5 * M_PI)
                                                           clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    [backCircle stroke];
    
    if (self.progress) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                                      radius:(CGRectGetWidth(self.bounds) - self.lineWidth ) / 2
                                                                  startAngle:(CGFloat) - M_PI_2
                                                                    endAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                                                                   clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        [progressCircle stroke];
    }
}

@end
