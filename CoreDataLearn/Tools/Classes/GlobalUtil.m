//
//  GlobalUtil.m
//  Juxiaocheng
//
//  Created by 高继鹏 on 16/1/28.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "GlobalUtil.h"

@implementation GlobalUtil

//获取城市字符UTF8编码
+ (NSString*)getDataUTF8:(NSString *)string
{
    NSString *dataUTF8 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return dataUTF8;
}

+ (UIBarButtonItem*)createBarButtonItemWithTitle:(NSString*)buttonTitle target:(id)target action:(SEL)action
{
    UIBarButtonItem* item = nil;
    item = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                            style:UIBarButtonItemStylePlain
                                           target:target
                                           action:action];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor darkGrayColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    return item;
}
+ (UIBarButtonItem*)createBarButtonItemWithImage:(NSString*)imageNa target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton *btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 5, 28, 28)];
    [btn2 setImage:[UIImage imageNamed:imageNa] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:imageNa] forState:UIControlStateHighlighted];
    [btn2 setTag:tag];
    [btn2 setContentMode:UIViewContentModeCenter];
    [btn2 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar2=[[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    return bar2;
}

/** 获取视频的宽度 */
+ (CGFloat)getVideoHeight
{
    CGFloat screenW = SCREEN_WIDTH;
    CGFloat videoHeight = screenW/16.0*9;
    return videoHeight;
}

#pragma mark 邮箱
+ (BOOL) validateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

#pragma mark 手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile

{
    //手机号以开头，八个 \d 数字字符
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|4[0-9]|7[0-9]|8[0235-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobile];
    
}

#pragma mark 用户名
+ (BOOL) validateUserName:(NSString *)name

{
    NSString *regi=@"^[\u4E00-\u9FFF]+$";
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regi];
    BOOL a=[pre evaluateWithObject:name];
    if (a==YES) {
        return a;
    }
    NSString *userNameRegex = @"^[A-Za-z]+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
    
}

#pragma mark 密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9_]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

#pragma mark 昵称
+ (BOOL) validateNickname:(NSString *)nickname

{
    
    NSString *nicknameRegex = @"^[\u4E00-\u9FA5A-Za-z0-9_]{2,15}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

#pragma mark 身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark 字符串转换
+(NSString *)changeUrlToUTF:(NSString *)nurl{
    //   NSString *murl=[nurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* murl =[nurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:nurl]];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);//gbk code-->utf8 code
    NSData*data = [murl dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString*utf8str = [[NSString alloc] initWithData:data encoding:enc];
    return utf8str;
}

#pragma mark 计算文件大小
+(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark 计算文件夹大小
+(float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (UIImage *)scaleImage:(UIImage *)image toNewSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur), nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil]; // save it to self.context
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage* output = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return output;
}

+ (NSString*)getMoneyString:(CGFloat)money{
    // 整数部分
    CGFloat wholeInteger = floor(money);
    // 小数部分
    CGFloat decimalPart = money - wholeInteger;
    if (decimalPart > 0.0) {
        return [NSString stringWithFormat:@"%.2f", money];
    } else {
        return [NSString stringWithFormat:@"%.0f", money];
    }
}

#pragma mark 处理数组或字典中包含NSNull
+ (void)deepCleanCollection:(id<NSFastEnumeration>)collection{
    id instance = collection;
    if ([instance isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* dict = instance;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(NSFastEnumeration)]) {
                [self deepCleanCollection:obj];
            } else {
                if (obj == [NSNull null]) {
                    [dict setValue:@"" forKey:key];
                }
            }
        }];
    } else if ([instance isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray* array = instance;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(NSFastEnumeration)]) {
                [self deepCleanCollection:obj];
            } else {
                if (obj == [NSNull null]) {
                    [array replaceObjectAtIndex:idx withObject:@""];
                }
            }
        }];
    }
}

//获取正确的图片路径
+ (NSString *)GetCorrectImageURLString:(NSString *)imageURLString
{
    NSString *headImageUrl = nil;
    if (imageURLString == nil || [imageURLString isEqualToString:@""]) {
        return @"";
    }
    
    if ([imageURLString hasPrefix:@"http://"]) {
        headImageUrl = imageURLString;
    } else {
        if ([imageURLString hasPrefix:@"/"]) {
            headImageUrl = [NSString stringWithFormat:@"%@%@",PublicURL,imageURLString];
        } else {
            headImageUrl = [NSString stringWithFormat:@"%@/%@",PublicURL,imageURLString];
        }
    }
    NSString *urlStr = [headImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlStr;
}

#pragma mark 图片压缩
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+ (NSDictionary *)dictionaryWithjsonData:(NSData *)jsonData
{
    if (jsonData == nil) {
        
        return nil;
        
    }
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)JsonString
{
    if (JsonString == nil) {
        
        return nil;
        
    }
    NSData *jsonData = [JsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
}

//处理文章的格式 -关于、规则等
+ (NSAttributedString *)handleArticleWithAttributeStringFromHTML:(NSString *)HTMLTypeString
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[HTMLTypeString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

//获得当前时间
+ (NSString *)nowTime
{
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:now];
    int hour = (int)[comps hour];
    int min = (int)[comps minute];
    int sec = (int)[comps second];
    int sum = (hour*3600+min*60+sec)*1000;
    NSString *time = [NSString stringWithFormat:@"%d",sum];
    return time;
}

//时间戳转时间的方法:
+ (NSString *)getMoreDateFromString:(NSString *)timeString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM.dd"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:localzone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    NSLog(@"confromTimesp  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

//将时间戳转字符串，格式:2016年07月19日
+ (NSString *)getMoreCharacterDateFromString:(NSString *)timeString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:localzone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    NSLog(@"confromTimesp  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

//把字典和数组转换成json字符串
+ (NSString *)stringTOjson:(id)temps
{
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:temps
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strs=[[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
    return strs;
}

- (BOOL)isAllowedNotification
{
    if (IS_IOS8) {// system is iOS8 +
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }else{// iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

#pragma mark - 时间戳处理
+ (BOOL)isBiggerThanNow:(NSDate *)inputDate
{
    NSInteger nowTime = [inputDate timeIntervalSinceNow];
    if (nowTime>-2*60) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isBeginTimeBiggerThanNow:(NSDate *)inputDate
{
    NSInteger nowTime = [inputDate timeIntervalSinceNow];
    if (nowTime>-60) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isMoreThanOneYear:(NSDate *)inputDate
{
    NSInteger nowTime = [inputDate timeIntervalSinceNow];
    if (nowTime<-60*60*365*24) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isATime:(NSDate *)A IsBiggerThanBTime:(NSDate *)B
{
    NSInteger aTime = [A timeIntervalSinceDate:B];
    if (aTime>=60 || aTime == 0) {
        return YES;
    }else{
        return NO;
    }
}

//月数
+ (NSString *)monthStringOfDateWithTimeString:(NSString *)timeStr
{
    NSDate *selfDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; // 新方法
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:selfDate];
//    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
//    NSInteger week = [dateComponent weekday];
//    NSInteger day = [dateComponent day];
//    NSInteger hour = [dateComponent hour];
//    NSInteger minute = [dateComponent minute];
//    NSInteger second = [dateComponent second];
    
//    NSLog(@"year is: %ld", year);
    NSLog(@"month is: %ld", (long)month);
//    NSLog(@"week is: %ld", week);
//    NSLog(@"day is: %ld", day);
//    NSLog(@"hour is: %ld", hour);
//    NSLog(@"minute is: %ld", minute);
//    NSLog(@"second is: %ld", second);
//    NSLog(@"calendar:%@",calendar);
    
    GlobalUtil *util = [[GlobalUtil alloc] init];
    return [util handleStringWithInteger:month];
}

//天数
+ (NSString *)dayStringOfDateWithTimeString:(NSString *)timeStr
{
    NSDate *selfDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; // 新方法
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:selfDate];
//    NSInteger year = [dateComponent year];
//    NSInteger month = [dateComponent month];
//    NSInteger week = [dateComponent weekday];
    NSInteger day = [dateComponent day];
//    NSInteger hour = [dateComponent hour];
//    NSInteger minute = [dateComponent minute];
//    NSInteger second = [dateComponent second];
    
//    NSLog(@"year is: %ld", year);
//    NSLog(@"month is: %ld", month);
//    NSLog(@"week is: %ld", week);
//    NSLog(@"day is: %ld", day);
//    NSLog(@"hour is: %ld", hour);
//    NSLog(@"minute is: %ld", minute);
//    NSLog(@"second is: %ld", second);
//    NSLog(@"calendar:%@",calendar);
    
    return [NSString stringWithFormat:@"%ld",(long)day];
}

- (NSString *)handleStringWithInteger:(NSInteger)monthInt
{
    switch (monthInt) {
        case 1:
            return @"一月";
            break;
        case 2:
            return @"二月";
            break;
        case 3:
            return @"三月";
            break;
        case 4:
            return @"四月";
            break;
        case 5:
            return @"五月";
            break;
        case 6:
            return @"六月";
            break;
        case 7:
            return @"七月";
            break;
        case 8:
            return @"八月";
            break;
        case 9:
            return @"九月";
            break;
        case 10:
            return @"十月";
            break;
        case 11:
            return @"十一月";
            break;
        case 12:
            return @"十二月";
            break;
            
        default:
            return @"";
            break;
    }
}

//判断日期是不是在今天
+ (BOOL)isTodayPublish:(NSString *)timeStr
{
    //前一天的
    NSDate *selfDate = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; // 新方法
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:selfDate];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger week = [dateComponent weekday];
    NSInteger day = [dateComponent day];
    
    //当前天的
    NSDate *today = [NSDate date];
    NSDateComponents *todayComponent = [calendar components:unitFlags fromDate:today];
    NSInteger todayYear = [todayComponent year];
    NSInteger todayMonth = [todayComponent month];
    NSInteger todayWeek = [todayComponent weekday];
    NSInteger todayDay = [todayComponent day];
    
    //比较
    if (year == todayYear) {
        if (month == todayMonth) {
            if (week == todayWeek) {
                if (day == todayDay) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

+ (BOOL)isLastDayIsEqualToCurrentDay:(NSString *)lastDay and:(NSString *)currentDay
{
    //前一天的
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[lastDay doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; // 新方法
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:lastDate];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger week = [dateComponent weekday];
    NSInteger day = [dateComponent day];
    
    //当前天的
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[currentDay doubleValue]];
    NSDateComponents *currentComponent = [calendar components:unitFlags fromDate:currentDate];
    NSInteger curYear = [currentComponent year];
    NSInteger curMonth = [currentComponent month];
    NSInteger curWeek = [currentComponent weekday];
    NSInteger curDay = [currentComponent day];
    
    //比较
    if (year == curYear) {
        if (month == curMonth) {
            if (week == curWeek) {
                if (day == curDay) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

/**
 *  获取剩余天数
 *
 *  @param timeStr 需判断的时间字符串
 *
 *  @return 是 或 不是
 */
+ (NSString *)isSurplusDate:(NSString *)timeStr
{
    NSInteger surplusTime = [timeStr integerValue];
    NSDate *currentDate = [NSDate date];
    NSInteger currentTime = [currentDate timeIntervalSince1970];
    if (surplusTime-currentTime<0) {
        return @"-1";
    }
    // 还未到截止日期
    NSInteger betweenTime = surplusTime-currentTime;
    NSInteger month = betweenTime / (3600 * 24 * 30);
    NSInteger days = betweenTime / (3600 * 24);
    NSInteger hours = betweenTime / 3600;
    NSInteger minutes = (betweenTime - (3600*hours)) / 60;
    NSInteger seconds = betweenTime % 60;
    if (month>0) {
        return [NSString stringWithFormat:@"%ld月",(long)month];
    }
    if (days>0) {
        return [NSString stringWithFormat:@"%ld天",(long)days];
    }
    if (hours>0) {
        return [NSString stringWithFormat:@"%ld小时",(long)hours];
    }
    if (minutes>0) {
        return [NSString stringWithFormat:@"%ld分钟",(long)minutes];
    }
    if (seconds>0) {
        return [NSString stringWithFormat:@"%ld秒",(long)minutes];
    }
    return @"-1";
}

//将base64字符串转成普通字符串
+ (NSString *)decodeBase64WithBase64String:(NSString *)baseStr
{
    NSData *baseData = [[NSData alloc] initWithBase64EncodedString:baseStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *resultStr = [[NSString alloc] initWithData:baseData encoding:NSUTF8StringEncoding];
    return resultStr;
}

//获取当前视图的控制器
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

#pragma mark - 处理崩溃日志信息
/** 是否有崩溃日志文件 */
+ (BOOL)hasCrashLogFile {
    // 寻找当前APP的Document路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // 在当前Document路径下创建文件夹
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    return existed;
}

/** 删除崩溃日志文件 */
+ (BOOL)deleteCrashLogFile {
    // 寻找当前APP的Document路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // 在当前Document路径下创建文件夹
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog"];
    
    NSError *error = nil;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(exists) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    }
    return exists;
}

/** 添加崩溃日志文件 */
+ (BOOL)addCrashLogFile:(NSString *)string {
    // 寻找当前APP的Document路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // 在当前Document路径下创建文件夹
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (!existed) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSData *fileData = [string dataUsingEncoding:NSUTF8StringEncoding];
    BOOL isSuccess = [fileData writeToFile:filePath atomically:YES];
    return isSuccess;
}

/** 读取崩溃日志文件 */
+ (NSString *)readCrashLogFile {
    // 寻找当前APP的Document路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // 在当前Document路径下创建文件夹
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"CrashLog"];
    
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString *fileStr = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    return fileStr;
}

@end
