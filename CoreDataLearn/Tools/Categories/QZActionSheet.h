//
//  QZActionSheet.h
//  Juxiaocheng
//
//  Created by 高继鹏 on 16/2/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QZActionSheetDelegate <NSObject>

@optional
- (void)qz_actionSheetDidSelectedIndex:(NSInteger)index;

@end

@interface QZActionSheet : UIView

@property (strong, nonatomic) id<QZActionSheetDelegate> delegate;

+ (instancetype)shareSheet;

/**
 *  区分取消和选择,使用array
 *  回调使用协议
 */
- (void)qz_actionSheetWithSelectArray:(NSArray *)array cancelTitle:(NSString *)cancel delegate:(id<QZActionSheetDelegate>)delegate;

@end
