//
//  IMALoginViewController.h
//  TIMChat
//
//  Created by AlexiChen on 16/2/26.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

/**
 *  封装的登录界面，拉起TLSUI的登录界面，实现TLS的代理，票据刷新，登录TLS，登录IMSDK等操作
 */

@interface IMALoginViewController : UIViewController//TencentSessionDelegate, WXApiDelegate,

@end
