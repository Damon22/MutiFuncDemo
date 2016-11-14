//
//  UIButton+timer.h
//  必胜课
//
//  Created by Damon on 15/9/16.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^InviteTimerBlock)();

@interface UIButton (timer)

@property (nonatomic, copy) InviteTimerBlock inviteTimerBlock;

- (void)addTimer;
- (void)intivteTimer;

@end
