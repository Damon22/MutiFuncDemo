//
//  DMBottomView.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/15.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//
// 保存 单独按钮

#import <UIKit/UIKit.h>

/** 默认View高度 145 */
static CGFloat DMBottomDefaultHeight = 145.0;

@interface DMBottomView : UITableViewCell

/** 背景 contentView: 设置 颜色 */
@property (weak, nonatomic) IBOutlet UIView *BGContentView;
/** 功能 按钮: 文本 颜色 */
@property (weak, nonatomic) IBOutlet UIButton *FuncButton;
/** 按钮 顶部距离:默认0 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FunButtonToUp;

/** 设置 背景颜色 */
- (void)setBGBackgroundColor:(UIColor *)backgroundColor;
/** 设置 按钮文本 */
- (void)setFuncButtonTitle:(NSString *)buttonTitle;
/** 设置 frame */
- (void)setDMBottomViewSize:(CGSize)newSize;
/** 设置 透明 默认:NO */
- (void)setBGTranslucent:(BOOL)isTranslucent;
/** 设置 顶部距离:默认0 */
- (void)setFuncButtonToUpConstent:(CGFloat)height;

/** 支付模式 */
- (void)isPayModel;
@property (nonatomic, assign) CGFloat cellHeight; // 支付模式有效

@end
