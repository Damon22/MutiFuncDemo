//
//  PayBottomCell.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/29.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayBottomCell : UITableViewCell

// cell 高度: 50.5

/** 价格 文本 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/** 价格 宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWidth;
/** 购买 状态 文本 */
@property (weak, nonatomic) IBOutlet UILabel *boughtStatusLabel;
/** 报名 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *signUpButtom;
/** 报名 按钮 右边距: 34 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpButtonRight;
/** 价格 文本 左边距: 15 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelLeft;
/** 价格 报名 中间距: 13 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceStatusLabelsWidth;
/** 价格 中间Y 距离: -1.5 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceToY;

@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

/** 已经报过名 */
- (void)haveSignUp:(NSString *)btnTitle;

/** 给cell添加 价格 和 销售量 */
- (void)cellWithPrice:(CGFloat)price andSaleNum:(NSInteger)saleNum;

@end
