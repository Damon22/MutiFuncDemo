//
//  SQinvationTime.m
//  获取时间差
//
//  Created by Damon on 15/10/12.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import "SQinvationTime.h"
#import "TMCache.h"

@implementation SQinvationTime

+ (NSString* )getNowTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateformat stringFromDate:date];
    return destDateString;
}

+ (NSString* )intervalSinceNow:(NSString *)theDateString
{
    
    NSString* lastAssToken = @"";
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDateString];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        lastAssToken = @"有效";

    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        if ([timeString integerValue] >=4) {
            lastAssToken = @"无效";
        }else
            lastAssToken = @"有效";
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        lastAssToken = @"有效";
    }
    NSLog(@"timeString:%@",timeString);
    return lastAssToken;
}


+ (NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(int)getHourSinceNowFromDateString:(NSString *)dateString
{
    NSDate *date = [self dateFromString:dateString];
    NSTimeInterval dateDiff = [date timeIntervalSinceNow];
    int hour = -trunc(dateDiff/(60*60));
    return hour;
}
+(int)getYearFormDateString:(NSString *)dateString
{
    NSDate *date = [SQinvationTime dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSInteger year = [dateComponent year];
    return (int)year;
}

+(NSString *)getAgeFormDateString:(NSString *)dateString
{
    NSDate *birthDate = [self dateFromString:dateString withFormat:@"yyyy-MM-dd"];
    NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
    
    int age=-trunc(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%d",age];
}
@end
