//
//  ShowAlertExamViewController.h
//  WinLesson
//
//  Created by 高继鹏 on 16/7/11.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ExamAlertItemType) {
    ExamAlertSubmit, // 提交 警告
    ExamAlertQuiet,  // 退出 警告
    ExamAlertNone    // 非 提交和退出
};

@protocol SelectAlertItemsDelegate;

@interface ShowAlertExamViewController : UIViewController

@property (nonatomic, weak) id<SelectAlertItemsDelegate> alertDelegate;
@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) ExamAlertItemType alertType;

- (void)setAlertTitleStr:(NSString *)titleStr;

- (void)show;

@end

#pragma mark - SelectItemsDelegate

@protocol SelectAlertItemsDelegate <NSObject>

@optional
/** 左按钮方法 取消 */
- (void)selectAlertLeftButton:(UIButton *)leftBtn;

@required
/** 右按钮方法 确定 */
- (void)selectAlertRightButton:(UIButton *)rightBtn;

@end