//
//  Breath.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 2016/12/14.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "Breath.h"

@implementation Breath

int breathNum = 0;

+ (void)haveBreath
{
    NSLog(@"have breath %d", breathNum++);
}

@end
