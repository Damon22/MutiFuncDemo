//
//  DMHudHelper.h
//  WinLesson
//
//  Created by 高继鹏 on 16/7/4.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface DMHudHelper : NSObject <MBProgressHUDDelegate>

@property(nonatomic, strong) MBProgressHUD *hud;

// 单例
+ (DMHudHelper *)sharedInstance;

// 在window上显示菊花转hud
- (void)showHudAcitivityOnWindow;

// 在window上显示hud
// 参数：
// caption:标题
// bActive：是否显示转圈动画
// time：自动消失时间，如果为0，则不自动消失

- (void)showHudOnWindow:(NSString *)caption
                  image:(UIImage *)image
              acitivity:(BOOL)bAcitve
           autoHideTime:(NSTimeInterval)time;

// 在当前的view上显示hud
// 参数：
// view：要添加hud的view
// caption:标题
// image:图片
// bActive：是否显示转圈动画
// time：自动消失时间，如果为0，则不自动消失
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time;

- (void)setCaption:(NSString *)caption;

// view  可点击返回按钮
- (void)showCommonHudOnView:(UIView *)view;
- (void)showLabelHudOnViewWithTitle:(NSString* )title view:(UIView* )view;

// window 不可点击
- (void)showCommonHudOnWindow;
- (void)showLabelHudOnWindowWithTitle:(NSString* )title;

/** 成功提示 */
- (void)showCustomHudOnWindowWithTitle:(NSString* )title;
/** 失败提示（有叉号） */
- (void)showCustomHudWithErrorOnWindowWithTitle:(NSString *)title;
- (void)showCustomHudOnViewWithTitle:(NSString* )title view:(UIView* )view;

// 隐藏hud
- (void)hideHud;

- (void)hideHudAfter:(NSTimeInterval)time;

@end
