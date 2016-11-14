//
//  DMHudHelper.m
//  WinLesson
//
//  Created by 高继鹏 on 16/7/4.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DMHudHelper.h"
#import "AppDelegate.h"

#define  _AppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@implementation DMHudHelper

// 单例
+ (DMHudHelper *)sharedInstance {
    static DMHudHelper *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

// 在window上显示菊花转hud
- (void)showHudAcitivityOnWindow {
    [self showHudOnWindow:nil image:nil acitivity:YES autoHideTime:6];
}

- (void)showHudOnWindow:(NSString *)caption
                  image:(UIImage *)image
              acitivity:(BOOL)active
           autoHideTime:(NSTimeInterval)time {
    
    if (_hud) {
        [_hud hideAnimated:NO];
    }
    
    self.hud = [[MBProgressHUD alloc] initWithView:_AppDelegate.window];
    [_AppDelegate.window addSubview:self.hud];
    self.hud.label.text = caption;
    self.hud.mode = active ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
    self.hud.animationType = MBProgressHUDAnimationFade;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud showAnimated:YES];
    time = 6;
    if (time > 0) {
        [self.hud hideAnimated:YES afterDelay:time];
    }
}

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)active
         autoHideTime:(NSTimeInterval)time {
    
    if (_hud) {
        [_hud hideAnimated:NO];
    }
    
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:self.hud];
    self.hud.label.text = caption;
    self.hud.mode = active ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
    self.hud.animationType = MBProgressHUDAnimationFade;
    [self.hud showAnimated:YES];
    if (time > 0) {
        [self.hud hideAnimated:YES afterDelay:time];
    }
}

- (void)setCaption:(NSString *)caption {
    self.hud.label.text = caption;
}

// view  可点击返回按钮
- (void)showCommonHudOnView:(UIView *)view {
    if (_hud) {
        [_hud hideAnimated:NO];
    }
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)showLabelHudOnViewWithTitle:(NSString* )title view:(UIView* )view {
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    self.hud.delegate = self;
    self.hud.label.text = title;
    [view addSubview:self.hud];
    [self.hud showAnimated:YES];
}

// window 不可点击
- (void)showCommonHudOnWindow {
    if (_hud) {
        [_hud hideAnimated:NO];
    }
    self.hud = [[MBProgressHUD alloc] initWithView:_AppDelegate.window];
    [_AppDelegate.window addSubview:self.hud];
    [self.hud showAnimated:YES];
}

- (void)showLabelHudOnWindowWithTitle:(NSString* )title {
    self.hud = [[MBProgressHUD alloc] initWithView:_AppDelegate.window];
    self.hud.delegate = self;
    self.hud.label.text = title;
    [_AppDelegate.window addSubview:self.hud];
    [self.hud showAnimated:YES];
}

/** 成功提示（有对勾） */
- (void)showCustomHudOnWindowWithTitle:(NSString* )title {
    self.hud = [[MBProgressHUD alloc] initWithView:_AppDelegate.window];
    [_AppDelegate.window addSubview:self.hud];
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    //self.hud.bezelView.color = COLOR_FontDeepBlack;
    self.hud.bezelView.color = [UIColor colorWithHex:0x0 alpha:0.8]; //0x282828
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.delegate = self;
    self.hud.label.text = title;
    self.hud.label.textColor = [UIColor whiteColor];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:1.5f];
}

/** 失败提示（有叉号） */
- (void)showCustomHudWithErrorOnWindowWithTitle:(NSString *)title {
    self.hud = [[MBProgressHUD alloc] initWithView:_AppDelegate.window];
    [_AppDelegate.window addSubview:self.hud];
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"差"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    //self.hud.bezelView.color = COLOR_FontDeepBlack;
    self.hud.bezelView.color = [UIColor colorWithHex:0x0 alpha:0.8]; //0x282828
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.delegate = self;
    self.hud.label.text = title;
    self.hud.label.textColor = [UIColor whiteColor];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:1.5f];
}

- (void)showCustomHudOnViewWithTitle:(NSString* )title view:(UIView* )view {
    self.hud = [[MBProgressHUD alloc] initWithView:_AppDelegate.window];
    [view addSubview:self.hud];
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    //self.hud.bezelView.color = COLOR_FontDeepBlack;
    self.hud.bezelView.color = [UIColor colorWithHex:0x0 alpha:0.8]; //0x282828
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.delegate = self;
    self.hud.label.text = title;
    self.hud.label.textColor = [UIColor whiteColor];
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:1.5f];
}

// 隐藏hud
- (void)hideHud {
    if (_hud) {
        [_hud hideAnimated:YES];
        [_hud removeFromSuperViewOnHide];
        _hud = nil;
    }
}

- (void)hideHudAfter:(NSTimeInterval)time {
    if (_hud) {
        [_hud hideAnimated:YES afterDelay:time];
    }
}

@end
