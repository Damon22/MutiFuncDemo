//
//  SQinvationTime.h
//  获取时间差
//
//  Created by Damon on 15/10/12.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQinvationTime : NSObject
/**获取当前时间*/
+ (NSString* )getNowTime;
/**检查当前时间距上次获取asstoken是否有4小时*/
+ (NSString* )intervalSinceNow:(NSString *)theDateString;

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

//得到小时
+(int)getHourSinceNowFromDateString:(NSString *)dateString;
//得到一个时间得年
+(int)getYearFormDateString:(NSString *)dateString;

+(NSString *)getAgeFormDateString:(NSString *)dateString;
@end
