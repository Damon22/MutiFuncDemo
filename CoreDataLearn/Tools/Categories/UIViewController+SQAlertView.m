//
//  UIViewController+SQAlertView.m
//  必胜课
//
//  Created by Damon on 15/10/28.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import "UIViewController+SQAlertView.h"

@implementation UIViewController (SQAlertView)

- (void)showAlertWithString:(id)sender
{
  //  UIAlertController* alert = [UIAlertController alertControllerWithTitle:sender message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    NSString* str = sender;
    if ([sender isKindOfClass:[NSDictionary class]]) {
       str = [self dictionaryToJson:sender];
    }    
    UIAlertView* alertv = [[UIAlertView alloc]initWithTitle:@"返回数据" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alertv show];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
