//
//  ScreenSizeCount.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/23.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ScreenSizeCount.h"

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

@implementation ScreenSizeCount

+ (CGFloat)currentViewWidth
{
    CGFloat viewHeight = SCREEN_WIDTH/4.0*3;
    return viewHeight;
}

@end
