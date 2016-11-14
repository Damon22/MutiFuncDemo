//
//  UIButton+DelayButtonClick.h
//  WinLesson
//
//  Created by 高继鹏 on 16/8/22.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DelayButtonClick)

/** 延迟sec秒执行button方法 */
- (void)buttonDelayForSec:(double)sec;

@end
