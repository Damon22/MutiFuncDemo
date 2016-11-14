//
//  UIViewController+tool.h
//  必胜课
//
//  Created by Damon on 15/9/18.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (tool)<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

-(UIView *)createGrayView;//灰色图层

//添加键盘监听
-(void)addKeyBoardNotificationWithHideKeyBoardAction:(SEL)hideKeyBoardAction andShowKeyBoardAction:(SEL)showKeyBoardAction;

//isAllow是否允许图片可编辑
-(void)createImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType isAllowEdit:(BOOL)isAllow;
@end
