//
//  UIViewController+tool.m
//  必胜课
//
//  Created by Damon on 15/9/18.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import "UIViewController+tool.h"

@implementation UIViewController (tool)

-(UIView *)createGrayView
{
    UIView *grayView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.5;
    grayView.hidden = YES;
    [self.view addSubview:grayView];
    
    return grayView;
}

//添加键盘监听
-(void)addKeyBoardNotificationWithHideKeyBoardAction:(SEL)hideKeyBoardAction andShowKeyBoardAction:(SEL)showKeyBoardAction
{
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:hideKeyBoardAction name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:showKeyBoardAction name:UIKeyboardWillShowNotification object:nil];
}

//相机或相册页面
-(void)createImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType isAllowEdit:(BOOL)isAllow
{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    __weak UIViewController *weakVC = self;
    imagePickerController.delegate = weakVC;
    
    imagePickerController.allowsEditing = isAllow;
    
    imagePickerController.sourceType = sourceType;
    
    /*
    //导航栏背景图片
    [imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px"] forBarMetrics:UIBarMetricsDefault];
    imagePickerController.navigationBar.shadowImage = [UIImage imageNamed:@"分割线.png"];
    // 导航栏按钮颜色
    [[UINavigationBar appearance] setBarTintColor:NavDefaultColor];
    imagePickerController.navigationBar.tintColor = NavDefaultColor;
    */
    
    imagePickerController.navigationBar.translucent = NO; //半透明效果
    imagePickerController.navigationBar.barTintColor = NavDefaultColor;
    
    //导航栏标题颜色
    [imagePickerController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TabBarDefaultFontColor,NSForegroundColorAttributeName,nil]];
    
    //导航栏按钮颜色
    [[UINavigationBar appearance] setTintColor:TabBarDefaultFontColor];
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

@end
