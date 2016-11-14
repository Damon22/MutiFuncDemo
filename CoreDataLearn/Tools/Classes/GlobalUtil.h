//
//  GlobalUtil.h
//  Juxiaocheng
//
//  Created by 高继鹏 on 16/1/28.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalUtil : NSObject

//处理文章的格式 -关于、规则等
+ (NSAttributedString *)handleArticleWithAttributeStringFromHTML:(NSString *)HTMLTypeString;

//获取当前时间
+ (NSString *)nowTime;

//将时间戳转字符串，格式:2015.07.19
+ (NSString *)getMoreDateFromString:(NSString *)timeString;

//将时间戳转字符串，格式:2016年07月19日
+ (NSString *)getMoreCharacterDateFromString:(NSString *)timeString;

//把字典和数组转换成json字符串
+ (NSString *)stringTOjson:(id)temps;

//获取城市字符UTF8编码
+ (NSString*)getDataUTF8:(NSString *)string;

+ (NSDictionary *)dictionaryWithjsonData:(NSData *)jsonData;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)JsonString;

/** 获取视频的宽度 */
+ (CGFloat)getVideoHeight;

//验证手机号是否合法
+ (BOOL) validateMobile:(NSString *)mobile;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//用户名
+ (BOOL) validateUserName:(NSString *)name;

//字符串编码转换
+(NSString *)changeUrlToUTF:(NSString *)nurl;

//计算文件大小
+(long long)fileSizeAtPath:(NSString*) filePath;

//计算文件夹大小
+(float) folderSizeAtPath:(NSString*) folderPath;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//自定义navagition item
+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action;

//自定义navagition item
+ (UIBarButtonItem*)createBarButtonItemWithImage:(NSString*)imageNa target:(id)target action:(SEL)action tag:(NSInteger)tag;

//缩放UIImage
+ (UIImage*)scaleImage:(UIImage*)image toNewSize:(CGSize)size;

//模糊图片
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//获取正确的图片路径
+ (NSString *)GetCorrectImageURLString:(NSString *)imageURLString;

//将钱从分转成元及字符串，自动判断是否应该有小数
+ (NSString*)getMoneyString:(CGFloat)money;

#pragma mark - 清理集合（Array & Dictionary）中的NSNull
+ (void)deepCleanCollection:(id<NSFastEnumeration>)collection;
//图片压缩
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
//字符串，转换json格式  dic

#pragma mark - 时间戳处理
+ (BOOL)isBiggerThanNow:(NSDate *)inputDate;

+ (BOOL)isATime:(NSDate *)A IsBiggerThanBTime:(NSDate *)B;

+ (BOOL)isBeginTimeBiggerThanNow:(NSDate *)inputDate;

/**
 *  月份
 *
 *  @return 返回月份（大写）
 */
+ (NSString *)monthStringOfDateWithTimeString:(NSString *)timeStr;

/**
 *  天数
 *
 *  @return 返回天数（数字）
 */
+ (NSString *)dayStringOfDateWithTimeString:(NSString *)timeStr;

/**
 *  超过一年
 *
 *  @param inputDate 当前日期
 *
 *  @return 是否超过一年时间
 */
+ (BOOL)isMoreThanOneYear:(NSDate *)inputDate;

/**
 *  判断日期是不是在今天
 *
 *  @param timeStr 需判断的时间字符串
 *
 *  @return 是 或 不是
 */
+ (BOOL)isTodayPublish:(NSString *)timeStr;

/**
 *  获取剩余天数
 *
 *  @param timeStr 需判断的时间字符串
 *
 *  @return 是 或 不是
 */
+ (NSString *)isSurplusDate:(NSString *)timeStr;

/**
 *  判断前一天的日期和今天是否一样
 *
 *  @param lastDay    前一天
 *  @param currentDay 当前天
 *
 *  @return 是 或 不是
 */
+ (BOOL)isLastDayIsEqualToCurrentDay:(NSString *)lastDay and:(NSString *)currentDay;

/**
 *  将base64字符串解码为普通字符串
 *
 *  @param baseStr base64字符串
 *
 *  @return 解码后的字符串
 */
+ (NSString *)decodeBase64WithBase64String:(NSString *)baseStr;

/**
 *  获取当前页面的控制器
 *
 *  @return 当前页面控制器
 */
+ (UIViewController *)getCurrentVC;

+ (UIViewController*)topViewController;

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

#pragma mark - 处理崩溃日志信息
/** 是否有崩溃日志文件 */
+ (BOOL)hasCrashLogFile;

/** 删除崩溃日志文件 */
+ (BOOL)deleteCrashLogFile;

/** 添加崩溃日志文件 */
+ (BOOL)addCrashLogFile:(NSString *)string;

/** 读取崩溃日志文件 */
+ (NSString *)readCrashLogFile;

@end
