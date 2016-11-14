//
//  UIViewController+addNavBtn.h
//  必胜课
//
//  Created by Damon on 15/7/29.
//  Copyright (c) 2015年 com.shixi.必胜课 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (addNavBtn)
-(void)addBtnOnNavWithTitle:(NSString *)title andImageName:(NSString *)name andTarget:(id)target andAction:(SEL)action andFrame:(CGRect)frame andDirection:(LXDirection)direction;
-(void)titleWithSting:(NSString *)str;
@end
