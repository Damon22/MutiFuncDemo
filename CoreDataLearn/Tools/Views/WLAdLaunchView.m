//
//  WLAdLaunchView.m
//  WinLesson
//
//  Created by 高继鹏 on 16/8/16.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "WLAdLaunchView.h"

@implementation WLAdLaunchView

@synthesize launchImageView;
@synthesize skipButton;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

/** 过渡启动图片 */
- (void)launchImageViewWithImage:(UIImage *)image
{
    launchImageView = [[UIImageView alloc]initWithImage:image];
    launchImageView.contentMode = UIViewContentModeScaleAspectFill;
    launchImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:launchImageView];
    
    skipButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 55 , 25, 55, 25)];
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    skipButton.titleLabel.tintColor = [UIColor whiteColor];
    skipButton.backgroundColor = [UIColor clearColor];
    [skipButton.layer setMasksToBounds:YES];
    [skipButton.layer setCornerRadius:2.0];
    [skipButton.layer setBorderWidth:1.0];
    skipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    skipButton.alpha = 0.7;
    [skipButton addTarget:self action:@selector(launchImageViewDismissWith:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skipButton];
    skipButton.hidden = YES;
}

- (void)launchImageViewDismissWith:(finishBlock)finish
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.skipButton = nil;
        self.launchImageView.image = nil;
        [self.launchImageView removeFromSuperview];
        self.launchImageView = nil;
        if (finish) {
            finish(YES);
        }
    }];
}

@end
