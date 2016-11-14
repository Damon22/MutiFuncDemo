//
//  NSString+size.m
//  必胜课
//
//  Created by Damon on 15/9/16.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)
- (CGSize)getSizeWithMaxWidth:(CGFloat)maxWidth andFontSize:(CGFloat)fontSize
{
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return size;
}

@end
