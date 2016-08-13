//
//  BaseCircleView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "BaseCircleView.h"

@implementation BaseCircleView
{
    float _contentWidth;
    float _contentHeight;
    // 形状layer
    CAShapeLayer *_shapeLayer;
    //内容layer
    CAShapeLayer * _contentLayer;
    //内容变化层layer
    CALayer * _gradLayer;
    // 内部的图片
    UIImageView *_statusImage;
}

- (void)awakeFromNib
{
    [self reloadView];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self reloadView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self reloadView];
    }
    return self;
}

- (void)reloadView
{
    self.backgroundColor = [UIColor clearColor];
    // 取设置的而frame的最小长或宽作为内容区域
    _contentWidth = _contentHeight = (CGRectGetWidth(self.frame)>CGRectGetHeight(self.frame))?CGRectGetHeight(self.frame):CGRectGetWidth(self.frame);
    // 创建内容layer
    _contentLayer = [CAShapeLayer layer];
    _contentLayer.bounds = CGRectMake(0, 0, _contentWidth, _contentHeight);
    _contentLayer.position = CGPointMake(_contentWidth/2.0, _contentHeight/2.0);
    _contentLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    // 进行边界描绘，默认线宽4px
    /** 以右顶点开始
     -M_PI_2: 顶部、顺时针
     M_PI_2*3: 顶部、顺时针
     */
    UIBezierPath *pathT = [UIBezierPath bezierPathWithArcCenter:_contentLayer.position radius:(_contentWidth/2.0-1) startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    _contentLayer.path = pathT.CGPath;
    // 默认填充颜色为浅绿色c3edd9
    _contentLayer.fillColor = [UIColor whiteColor].CGColor;
    _contentLayer.lineWidth = 4.0f;
    _contentLayer.strokeColor = COLORWITH(@"c3edd9").CGColor; // 浅绿色c3edd9
    [self.layer addSublayer:_contentLayer];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, _contentWidth, _contentHeight);
    _shapeLayer.position = CGPointMake(_contentWidth/2.0, _contentHeight/2.0);
    _shapeLayer.backgroundColor = [UIColor clearColor].CGColor; // 这个改了，整个背景色都会被填充
//    _shapeLayer.lineCap  = kCALineCapRound; // 线头的样式，半圆形
    
    // 进行边界描绘，默认线宽为4px
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_shapeLayer.position radius:(_contentWidth/2.0-2) startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor; // 这个改了，整个图形都会被填充
    _shapeLayer.lineWidth = 4.0f;
    _shapeLayer.strokeColor = COLORWITH(@"2aab3d").CGColor; // 要改的颜色: 上层填充色 深绿色2aab3d （不能为透明色）
    // 默认深绿色的边界线，由gradLayer控制
    _gradLayer = [CALayer layer];
    _gradLayer.bounds = _contentLayer.bounds;
    _gradLayer.position = _contentLayer.position;
    _gradLayer.backgroundColor = COLORWITH(@"2aab3d").CGColor; // 要改的颜色: 上层填充色 深绿色2aab3d (最终决定上层的颜色)
    
    [_gradLayer setMask:_shapeLayer];
    [_contentLayer addSublayer:_gradLayer];
    
    _progress = 0.0;
    // 创建中间图片
    [self createMidPic];
}

- (void)createMidPic
{
    _statusImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _statusImage.contentMode = UIViewContentModeCenter;
    _statusImage.image = [UIImage imageNamed:@"暂停下载01"];
    self.circleStatus = DownloadBegin;
    [self addSubview:_statusImage];
    
}

/**
 设置当前状态
 */
- (void)setCurrentDownloadStatus:(DownloadStatus)currentStatus
{
    self.circleStatus = currentStatus;
    if (self.circleStatus == DownloadPause) {
        _statusImage.image = [UIImage imageNamed:@"下载01"];
    }else{
        _statusImage.image = [UIImage imageNamed:@"暂停下载01"];
    }
}

-(void)setLineWidth:(CGFloat)lineWidth{
    if (lineWidth<0.5) {
        lineWidth=0.5;
    }
    if (lineWidth>20) {
        lineWidth = 20;
    }
    _lineWidth = lineWidth;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:_shapeLayer.position radius:_contentWidth/2.0-lineWidth/2.0 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = lineWidth;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [_gradLayer setMask:_shapeLayer];
    UIBezierPath * pathT = [UIBezierPath bezierPathWithArcCenter:_contentLayer.position radius:_contentWidth/2.0-lineWidth/2.0 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    _contentLayer.path = pathT.CGPath;
    _contentLayer.lineWidth = lineWidth;
    
}

-(void)setTintColor:(UIColor *)tintColor{
    _lineTintColor = tintColor;
    _contentLayer.strokeColor = tintColor.CGColor;
}

-(void)setProgress:(CGFloat)progress{
    _progress=progress;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = progress>1?1:progress;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _progress = progress;
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.toValue = progress>1?@1:@(progress);
    ani.duration = 0.1;
    ani.delegate = self;
    ani.fillMode = kCAFillModeForwards;
    ani.removedOnCompletion = NO;
    [_shapeLayer addAnimation:ani forKey:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [_shapeLayer removeAllAnimations];
        _shapeLayer.strokeEnd = _progress>1?1:_progress;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
