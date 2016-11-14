//
//  WLAdLaunchView.h
//  WinLesson
//
//  Created by 高继鹏 on 16/8/16.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)(BOOL isFinish);

@interface WLAdLaunchView : UIView

@property (nonatomic, strong) UIImageView *launchImageView;

@property (nonatomic, strong) UIButton *skipButton;

- (void)launchImageViewWithImage:(UIImage *)image;

- (void)launchImageViewDismissWith:(finishBlock)finish;

@end
