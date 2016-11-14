//
//  ShareThirdView.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//
// 分享界面

#import <UIKit/UIKit.h>

@interface ShareThirdView : UITableViewCell

// cell 高度: 366

/** 标题 分享到 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 底部 关闭 视图 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/** 底部 关闭 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

/** 分享的 第三方 平台 数组 */
@property (nonatomic, strong) NSArray *thirdShareViewArr;
@property (nonatomic, assign) CGFloat cellHeight;

/** 分享视图 tag: 5000 */
@property (weak, nonatomic) IBOutlet UIView *thirdView1;
/** 分享视图 tag: 5001 */
@property (weak, nonatomic) IBOutlet UIView *thirdView2;
/** 分享视图 tag: 5002 */
@property (weak, nonatomic) IBOutlet UIView *thirdView3;
/** 分享视图 tag: 5003 */
@property (weak, nonatomic) IBOutlet UIView *thirdView4;
/** 分享视图 tag: 5004 */
@property (weak, nonatomic) IBOutlet UIView *thirdView5;

/** 分享 图片 tag: 5100 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
/** 分享 图片 tag: 5101 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
/** 分享 图片 tag: 5102 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
/** 分享 图片 tag: 5103 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
/** 分享 图片 tag: 5104 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;

/** 分享 标题 tag: 5200 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel1;
/** 分享 标题 tag: 5201 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;
/** 分享 标题 tag: 5202 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel3;
/** 分享 标题 tag: 5203 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel4;
/** 分享 标题 tag: 5204 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel5;

@end
