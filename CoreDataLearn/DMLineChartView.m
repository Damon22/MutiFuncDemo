//
//  DMLineChartView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/23.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DMLineChartView.h"

static const CGFloat kLabelW = 30.f;
static const CGFloat kLabelH = 10.f;
static const CGFloat kLineW = 1.f;

@implementation DMLineChartView

#pragma mark - set V line
- (void)setXAxis:(NSArray *)xAxis
{
    _xAxis = xAxis;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
