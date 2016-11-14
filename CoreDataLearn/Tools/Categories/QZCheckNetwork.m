//
//  QZCheckNetwork.m
//  必胜课
//
//  Created by Damon on 15/10/31.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import "QZCheckNetwork.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "GlobalUtil.h"

@implementation QZCheckNetwork
+(void)checkNetwork
{
    //开启网络监测状态提示
    
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    [reachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [[iToast makeText:@"世界上最遥远的距离就是没有网"]show];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
                
            default:
                break;
        }
    }];
    
    /*
    NSURL* netUrl = [NSURL URLWithString:@"http://baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:netUrl];
    NSOperationQueue* operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //[[iToast makeText:@"网络正常"]show];
                [operationQueue setSuspended:NO];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                [[iToast makeText:@"世界上最遥远的距离就是没有网"]show];
                [operationQueue setSuspended:YES];
                break;
                
            default:
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
     */
    
    // 上传Crash日志
    if ([GlobalUtil hasCrashLogFile]) {
        NSString *url = [NSString stringWithFormat:@"%@%@",PublicURL,@"CollapseLog/AddCollapseLog.json"];
        NSString *crashStr = [GlobalUtil readCrashLogFile];
        NSDictionary *dic = @{@"break_analysis" : crashStr};
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject objectForKey:@"ret"]) {
                if ([[responseObject objectForKey:@"ret"] intValue] == 200) {
                    // 删除崩溃日志
                    [GlobalUtil deleteCrashLogFile];
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error:上传crash%@",error);
        }];
    }
    
}

//检测联网状态
+ (BOOL)isNetworkConnected {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            return NO;
            break;
        case ReachableViaWWAN:
        case ReachableViaWiFi:
            return YES;
            break;
    }
}
@end
