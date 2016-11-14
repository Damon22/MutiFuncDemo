//
//  QZCheckNetwork.h
//  必胜课
//
//  Created by Damon on 15/10/31.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZCheckNetwork : NSObject
+(void)checkNetwork;
//检测联网状态
+ (BOOL)isNetworkConnected;
@end
