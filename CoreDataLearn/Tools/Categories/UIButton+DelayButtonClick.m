//
//  UIButton+DelayButtonClick.m
//  WinLesson
//
//  Created by 高继鹏 on 16/8/22.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "UIButton+DelayButtonClick.h"

@implementation UIButton (DelayButtonClick)

/** 延迟sec秒执行button方法 */
- (void)buttonDelayForSec:(double)sec
{
    self.userInteractionEnabled = NO;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
}

@end
