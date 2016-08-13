//
//  FlowerTransformView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/7/30.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "FlowerTransformView.h"

static inline CGAffineTransform
CGAffineTramsformMakeScaleTranslate(CGFloat sx, CGFloat sy, CGFloat dx, CGFloat dy) {
    return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

@implementation FlowerTransformView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    CGFloat margin = 10;
    CGFloat radius = 1;
    
    [[UIColor redColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(0, -1)
                    radius:radius
                startAngle:-M_PI
                  endAngle:0
                 clockwise:YES];
    [path addArcWithCenter:CGPointMake(1, 0)
                    radius:radius
                startAngle:-M_PI_2
                  endAngle:M_PI_2
                 clockwise:YES];
    [path addArcWithCenter:CGPointMake(0, 1)
                    radius:radius
                startAngle:0
                  endAngle:M_PI
                 clockwise:YES];
    [path addArcWithCenter:CGPointMake(-1, 0)
                    radius:radius
                startAngle:M_PI_2
                  endAngle:-M_PI_2
                 clockwise:YES];
    [path closePath];
    
    CGFloat scale = floorf((MIN(size.height, size.width) - margin) / 4);
    
    CGAffineTransform transform;
    transform = CGAffineTramsformMakeScaleTranslate(scale,
                                                    scale,
                                                    size.width/2,
                                                    size.height/2);
    [path applyTransform:transform];
    [path fill];
}


@end
