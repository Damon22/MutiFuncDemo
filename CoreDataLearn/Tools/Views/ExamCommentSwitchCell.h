//
//  ExamCommentSwitchCell.h
//  WinLesson
//
//  Created by 高继鹏 on 16/7/7.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamCommentSwitchCell : UITableViewCell

// cell 高度: 40.5

@property (weak, nonatomic) IBOutlet UILabel *upLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineHeight;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;

@property (weak, nonatomic) IBOutlet UILabel *midLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLineWidth;

/** 左按钮 */
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
/** 右按钮 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
