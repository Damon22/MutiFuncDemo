//
//  DMSwitch.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/14.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMSwitchStyle) {
    DMSwitchStyleNoBorder,
    DMSwitchStyleBorder
};

@interface DMSwitch : UIControl

@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, assign) DMSwitchStyle style;

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIColor *onTextColor;
@property (nonatomic, strong) UIColor *offTextColor;
@property (nonatomic, strong) UIFont  *textFont;
@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;
@property (nonatomic, assign) CGFloat fontSize;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
