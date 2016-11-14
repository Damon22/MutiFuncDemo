//
//  UIViewController+addNavBtn.m
//  必胜课
//
//  Created by Damon on 15/7/29.
//  Copyright (c) 2015年 com.shixi.必胜课 All rights reserved.
//

#import "UIViewController+addNavBtn.h"

@implementation UIViewController (addNavBtn)
/**
 添加左右导航栏按钮
 */
-(void)addBtnOnNavWithTitle:(NSString *)title andImageName:(NSString *)name andTarget:(id)target andAction:(SEL)action andFrame:(CGRect)frame andDirection:(LXDirection)direction
{
    //
    //在导航栏添加按钮
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    if (direction == LEFT) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
}
//导航栏上的标题
-(void)titleWithSting:(NSString *)str
{
    UILabel* titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [titlelabel setText:str];
    [titlelabel setTextColor:[UIColor whiteColor]];
    [titlelabel setFont:[UIFont systemFontOfSize:19]];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = titlelabel;
}
@end
