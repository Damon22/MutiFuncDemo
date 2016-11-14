//
//  NSString+Helpers.h
//  xc
//
//  Created by TopDev on 9/28/14.
//  Copyright (c) 2014 TopDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

- (NSString *)MD5;

- (bool)isEmpty;
- (NSString *)trim;
- (NSNumber *)numericValue;
- (NSUInteger)integerValueFromHex;

// 字数计算，中文占1个，英文占半个
- (NSInteger)countWord;
// 根据给定的字数(中文占1个，英文占半个)获得长度，用于截取字符串
- (NSInteger)realIndexWithCount:(NSInteger)count;
// 判断是否全是空格
- (BOOL)isAllBlank;

@end

@interface NSObject (NumericValueHack)
- (NSNumber *)numericValue;

@end
