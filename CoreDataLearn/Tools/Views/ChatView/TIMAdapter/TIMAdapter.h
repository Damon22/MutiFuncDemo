//
//  TIMAdapter.h
//  TIMAdapter
//
//  Created by AlexiChen on 16/1/29.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QALSDK/QalSDKProxy.h>

#import <ImSDK/ImSDK.h>

#import <TLSSDK/TLSHelper.h>

#define kUserInputStatus @"kUserInputStatus"
#define kSaftyWordsCode 80001

#define kGetConverSationList 0
#define kSupportCustomConversation 1

typedef NS_ENUM(NSInteger, IMAConType)
{
    IMA_Unknow,                     // 未知
    IMA_C2C = TIM_C2C,              // C2C类型
    IMA_Group = TIM_GROUP,          // 群聊类型
    IMA_System = TIM_SYSTEM,        // 系统消息
    // 定制会话类型
    IMA_Connect,                    // 网络联接
    
    //    kSupportCustomConversation 为 1时有效
    IMA_Sys_NewFriend,              // 新朋友系统消息
    IMA_Sys_GroupTip,               // 群系统消息通知
    
};

//==============================

// 用户更新为自己的app配置

#define kSdkAccountType @"792"
#define kQQAccountType  1
#define kWXAccountType  2


// 最大昵称UTF8字符串长度
#define kNicknameMaxLength  64

#define kDefaultUserIcon            [UIImage imageNamed:@"default_user"]
#define kDefaultGroupIcon           [UIImage imageNamed:@"default_group"]
#define kDefaultSystemIcon          [UIImage imageNamed:@"default_system"]


//==============================
// 聊天图片缩约图最大高度
#define kChatPicThumbMaxHeight 190.f
// 聊天图片缩约图最大宽度
#define kChatPicThumbMaxWidth 66.f

//==============================

// IMAMsg扩展参数的键
#define kIMAMSG_Image_ThumbWidth    @"kIMA_ThumbWidth"
#define kIMAMSG_Image_ThumbHeight   @"kIMA_ThumbHeight"
#define kIMAMSG_Image_OrignalPath   @"kIMA_OrignalPath"
#define kIMAMSG_Image_ThumbPath     @"kIMA_ThumbPath"

//==============================

// IMA中用到的消息相关通知
#define kIMAMSG_DeleteNotification @"kIMAMSG_DeleteNotification"
#define kIMAMSG_ResendNotification @"kIMAMSG_ResendNotification"
#define kIMAMSG_ChangedNotification @"kIMAMSG_ChangedNotification"

#define kIMAMSG_ReloginNotification @"kIMAMSG_ReloginNotification"

//==============================

#define IMALocalizedError(intCode, enStr) NSLocalizedString(([NSString stringWithFormat:@"%d", (int)intCode]), enStr)

//==============================
// IMA内部使用的字休
#define kIMALargeTextFont       [UIFont systemFontOfSize:16]
#define kIMAMiddleTextFont      [UIFont systemFontOfSize:14]
#define kIMASmallTextFont       [UIFont systemFontOfSize:12]




#import "IMAShow.h"

#import "IMAModel.h"

#import "IMAPlatformHeaders.h"

#import "IMAAppDelegate.h"
