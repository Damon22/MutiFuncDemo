//
//  Lungs.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 2016/12/14.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "Lungs.h"
#import "Breath.h"

@implementation Lungs

- (void)tryBreath
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:(@selector(countTime)) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)countTime
{
    [Breath haveBreath];
}

@end
