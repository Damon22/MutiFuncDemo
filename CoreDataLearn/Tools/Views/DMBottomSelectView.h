//
//  DMBottomSelectView.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/16.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//
// 全选 删除 按钮

#import <UIKit/UIKit.h>

@interface DMBottomSelectView : UITableViewCell

// 默认高度: 50

/** 左按钮 */
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
/** 右按钮 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
/** View 背景 */
@property (weak, nonatomic) IBOutlet UIView *selectBGView;

@property (weak, nonatomic) IBOutlet UILabel *midLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLineBottom;

- (void)setLeftButton:(NSString *)Ltitle RightButton:(NSString *)Rtitle;

@end
