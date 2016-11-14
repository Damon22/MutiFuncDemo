//
//  NSString+sawNum.m
//  Juxiaocheng
//
//  Created by HERO-PC on 16/2/25.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "NSString+sawNum.h"

@implementation NSString (sawNum)
- (NSString *)sawNumWithString{
    uint sawNum = [self intValue];
    if(sawNum >9999 && sawNum <= 999999){
        return [NSString stringWithFormat:@"%d万",sawNum/10000];
    }else if (sawNum >999999){
        return [NSString stringWithFormat:@"超过百万"];
    }else{
        return [NSString stringWithFormat:@"%d",sawNum];
    }
}
@end
