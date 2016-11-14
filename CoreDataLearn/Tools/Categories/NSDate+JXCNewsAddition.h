//
//  NSDate+JXCNewsAddition.h
//  Juxiaocheng
//
//  Created by 高继鹏 on 16/2/28.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JXCNewsAddition)

/**
 *  转换时间（n天前）
 *
 *  @return n天前、n分钟前
 */
- (NSString *)transformToFuzzyDate;

/**
 *  转换时间（时：分：秒）
 *
 *  @return 时：分：秒：上午：下午
 */
- (NSString *)promptDateString;

/**
 *  一般样式
 *
 *  @return 年-月-日 时：分
 */
- (NSString *)formalDateString;

@end
