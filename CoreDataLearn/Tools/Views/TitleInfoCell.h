//
//  TitleInfoCell.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/16.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamItemHelper.h"

@class MyMessageModel;
// 默认高度 70
/** 默认View高度 70 */
static CGFloat DefaultHeight = 70.0;

@interface TitleInfoCell : UITableViewCell
/** cell 标题 默认左边距:23 */
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
/** cell 日期 默认左边距:23 */
@property (weak, nonatomic) IBOutlet UILabel *cellDate;
/** cell 详情 */
@property (weak, nonatomic) IBOutlet UILabel *cellInfoLabel;
/** cell icon图片 */
@property (weak, nonatomic) IBOutlet UIImageView *cellIconImage;
@property (weak, nonatomic) IBOutlet UIButton *checkMoreBtn;


/** cell 标题 默认左边距:23 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTitleLeft;
/** cell 标题 默认距中:-12 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTitleCenterY;
/** cell 日期 默认左边距:23 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellDateLeft;
/** cell 日期 默认距中:14 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellDateCenterY;

@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

/** 控制器 类型 */
@property (nonatomic, assign) VCType viewControllType;

/** 设置 info 内容  */
- (void)setInfoStr:(NSDictionary *)infoDic;

/** 我的消息 设置 */
- (void)setCellWithModel:(MyMessageModel *)model;

@end
