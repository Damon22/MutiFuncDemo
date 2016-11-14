
//
//  QZStandardString.m
//  必胜课
//
//  Created by Damon on 15/10/23.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import "QZStandardString.h"

@implementation QZStandardString
+(NSString *)standardString:(id)obj
{
    if([obj isKindOfClass:[NSNull class]] || obj == nil){
        return @"";
    }else if(![obj isKindOfClass:[NSString class]]){
        return [NSString stringWithFormat:@"%@",obj];
    }
    return obj;
}

@end
