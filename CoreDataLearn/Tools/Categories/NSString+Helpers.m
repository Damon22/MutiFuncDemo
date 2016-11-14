//
//  NSString+Helpers.m
//  xc
//
//  Created by TopDev on 9/28/14.
//  Copyright (c) 2014 TopDev. All rights reserved.
//

#import "NSString+Helpers.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Helpers)

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (bool)isEmpty {
    return self.length == 0;
}

- (NSString *)trim {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSNumber *)numericValue {
    return [NSNumber numberWithUnsignedLongLong:[self longLongValue]];
}

- (NSUInteger)integerValueFromHex
{
    unsigned long result = 0;
    sscanf([self UTF8String], "%lx", &result);
    return (NSUInteger)result;
}


- (NSInteger)countWord
{
    NSInteger i,n=[self length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
//    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

- (NSInteger)realIndexWithCount:(NSInteger)count
{
    NSInteger i,n=[self length],r = 0;
    unichar c;
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(isblank(c)){
            r++;
        }else if(isascii(c)){
            r++;
        }else{
            r += 2;
        }
        
        if (r == count*2) {
            return i+1;
        } else if (r > count*2) {
            return i;
        }
    }
    
    return n;
}

- (BOOL)isAllBlank
{
    NSInteger i,n=[self length];
    unichar c;
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(!isblank(c)){
            return NO;
        }
    }
    
    return YES;
}

@end

@implementation NSObject (NumericValueHack)
- (NSNumber *)numericValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self;
    }
    return nil;
}
@end
