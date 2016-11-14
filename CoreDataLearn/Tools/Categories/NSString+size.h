//
//  NSString+size.h
//  必胜课
//
//  Created by Damon on 15/9/16.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (size)
- (CGSize)getSizeWithMaxWidth:(CGFloat)maxWidth andFontSize:(CGFloat)fontSize;
@end
