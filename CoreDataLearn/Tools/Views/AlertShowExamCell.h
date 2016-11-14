//
//  AlertShowExamCell.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//
// 提醒用户 交卷

#import <UIKit/UIKit.h>

@interface AlertShowExamCell : UITableViewCell

// cell frame: 300 , 146

/** 展示的View */
@property (weak, nonatomic) IBOutlet UIView *showView;
/** 取消 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/** 确定 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
/** 详情 信息 Label */
@property (weak, nonatomic) IBOutlet UILabel *infoStrLabel;

/** line */
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *midLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLineWidth;

@end
