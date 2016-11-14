//
//  FileManager.m
//  WinLesson
//
//  Created by 高继鹏 on 16/9/14.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "FileManager.h"
#import "TYDownloadSessionManager.h"
#import "TYDownLoadDataManager.h"
#import "TYDownLoadUtility.h"
#import "TYDownloadModel.h"
#import "DownloadLocalModel.h"

@interface FileManager ()

/** 所有下载文件的存储路径 */
@property (nonatomic, strong) NSString *defaultDirectory;
/** 对应用户的文件路径 */
@property (nonatomic, strong) NSString *userDirectory;

@end

@implementation FileManager

static FileManager *_shareFileManager;

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFileManager = [[self alloc] init];
        _shareFileManager.downloadList = [NSMutableArray arrayWithCapacity:10];
    });
    return _shareFileManager;
}

/** 根据model下载讲义并返回结果 */
- (void)getDownloadWith:(TYDownloadModel *)downloadModel
            andFileName:(NSString *)fileName
            andCourseId:(NSString *)courseId
          andCourseName:(NSString *)courseName
                 Result:(downloadSuccessBlock)successBlock
{
    if ([[TYDownloadSessionManager manager] isDownloadCompletedWithDownloadModel:downloadModel]) {
        if (successBlock) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            successBlock(YES, downloadModel.filePath);
        }
    } else {
        if (downloadModel.state != TYDownloadStateRunning) {
            __block NSString *fileSize = nil;
            __weak typeof(self) weakSelf = self;
            TYDownloadSessionManager *manager = [TYDownloadSessionManager manager];
            [manager startWithDownloadModel:downloadModel progress:^(TYDownloadProgress *progress) {
                
                NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                             [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                             [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];
                if ([[NSString stringWithFormat:@"%.2f",
                      [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite]] isEqualToString:@"1.00"]) {
                    NSLog(@"fileSizeInUnits:%@",fileSizeInUnits);
                }
                fileSize = fileSizeInUnits;
            } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
                if (state == TYDownloadStateCompleted) {
                    [weakSelf storageFileToManager:fileName storeId:downloadModel.fileName size:fileSize path:filePath and:courseId and:courseName and:nil and:nil andType:PDFType];
                    if (successBlock) {
                        successBlock(YES, filePath);
                    }
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                } else if (state == TYDownloadStateFailed) {
                    [[iToast makeText:@"下载失败"] show];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                } else if (state == TYDownloadStateRunning) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                } else {
                     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }
                NSLog(@"state %ld error%@ filePath%@",(unsigned long)state,error,filePath);
            }];
        }
    }
}

/** 判断文件是否下载 */
- (BOOL)checkoutDownloadState:(TYDownloadModel *)downloadModel
{
    if ([[TYDownloadSessionManager manager] isDownloadCompletedWithDownloadModel:downloadModel]) {
        return YES;
    } else {
        return NO;
    }
}

/** 根据name获取 TYDownloadModel */
- (TYDownloadModel *)modelWithDownloadName:(NSString *)name
{
    TYDownloadModel *resultModel = nil;
    for (TYDownloadModel *model in self.downloadList) {
        if ([model.fileName isEqualToString:name]) {
            resultModel = model;
            break;
        }
    }
    return resultModel;
}

/** 获取正确的打开路径 */
- (NSString *)getCorrectLocalPath:(NSString *)localPath
{
    NSRange range = [localPath rangeOfString:@"Documents/"];
    NSString *partPath = [localPath substringFromIndex:(range.length+range.location)];
    NSLog(@"partPath:%@",partPath);
    partPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:partPath];
    return partPath;
}

#pragma mark 创建文件夹
/** 创建默认的文件夹: 在刚创建的时候 就要设置
 如果有则不创建
 没有则创建
 */
- (void)defaultFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileDir = [self defaultDirectory];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDir]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"createDirectory:%@ error:%@",fileDir, error);
        } else {
            NSLog(@"createDirectory:%@ success",fileDir);
        }
    }
}

/** 创建用户的文件夹: 在用户登录后创建
 如果有则不创建
 没有则创建
 */
- (void)userDirectoryFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileDir = [self userDirectory];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:fileDir isDirectory:&isDir]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"createDirectory:%@ error:%@",fileDir, error);
        } else {
            NSLog(@"createDirectory:%@ success",fileDir);
            NSMutableArray *videoArr = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *keynoteArr = [NSMutableArray arrayWithCapacity:10];
            NSDictionary *managerDic = @{@"videoArr"    :   videoArr,
                                         @"keynoteArr"  :   keynoteArr};
            if ([self writeToFileWithPath:fileDir and:managerDic]) {
                NSLog(@"文件管理 存储成功");
            }
        }
    }
    // 视频
    NSString *videoFile = [NSString stringWithFormat:@"%@/video",[self userDirectory]];
    if (![fileManager fileExistsAtPath:videoFile isDirectory:&isDir]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:videoFile withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"createDirectory:%@ error:%@",videoFile, error);
        } else {
            NSLog(@"createDirectory:%@ success",videoFile);
        }
    }
    // 讲义（课件）
    NSString *keynoteFile = [NSString stringWithFormat:@"%@/keynotes",[self userDirectory]];
    if (![fileManager fileExistsAtPath:keynoteFile isDirectory:&isDir]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:keynoteFile withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"createDirectory:%@ error:%@",keynoteFile, error);
        } else {
            NSLog(@"createDirectory:%@ success",keynoteFile);
        }
    }
}

#pragma mark 路径
/** 文件夹默认的路径：
 [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offlinedata"];
 */
- (NSString *)defaultDirectory
{
    if (!_defaultDirectory) {
        _defaultDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offlinedata"];
    }
    return _defaultDirectory;
}

/** 用户个人的下载文件夹路径 /defaultDirectory/userId/xxx.mp4 */
- (NSString *)userDirectory
{
    if (!_userDirectory) {
        _userDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"offlinedata/%@",[WLUserInfo userId]]];
    }
    return _userDirectory;
}

#pragma mark 文件操作
/** 存储PDF文件 */
- (void)storageFileToManager:(NSString *)fileName
                     storeId:(NSString *)fileId
                        size:(NSString *)fileSize
                        path:(NSString *)filePath
                         and:(NSString *)courseId
                         and:(NSString *)courseName
                         and:(NSString *)videoDuration
                         and:(NSString *)videoTeachers
                     andType:(StorageType)type
{
    NSDictionary *managerDic = [self getManagerDic];
    NSMutableArray *tempArr = nil;
    if (type == PDFType) {
        // pdf文件
        tempArr = managerDic[@"keynoteArr"];
    } else {
        tempArr = managerDic[@"videoArr"];
    }

    BOOL hasDownload = NO;
    for (DownloadLocalModel *model in tempArr) {
        if ([fileId isEqualToString:model.fileId]) {
            hasDownload = YES;
            break;
        }
    }
    if (hasDownload) {
        NSLog(@"fileId:%@ 已经存在",fileId);
        return;
    }
    
    DownloadLocalModel *downloadModel = [[DownloadLocalModel alloc] init];
    downloadModel.fileName = fileName;
    downloadModel.fileId = fileId;
    downloadModel.fileSize = fileSize;
    downloadModel.filePath = filePath;
    downloadModel.courseName = courseName;
    downloadModel.courseId = courseId;
    downloadModel.videoDuration = videoDuration;
    downloadModel.videoTeachers = videoTeachers;
    if (type == PDFType) {
        // pdf文件
        downloadModel.downloadType = DownloadPDFType;
    } else {
        downloadModel.downloadType = DownloadVideoType;
    }
    
    [tempArr addObject:downloadModel];
    NSString *fileDir = [self userDirectory];
    if ([self writeToFileWithPath:fileDir and:managerDic]) {
        NSLog(@"文件管理%@ 存储成功",fileId);
    }
}

// 写入存储文件
- (BOOL)writeToFileWithPath:(NSString *)fileDir and:(NSDictionary *)managerDic
{
    // 创建归档时所需的data 对象.
    NSMutableData *data = [NSMutableData data];
    
    // 归档类.
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 开始归档（@"model" 是key值，也就是通过这个标识来找到写入的对象）.
    [archiver encodeObject:managerDic forKey:@"FileManagerDic"];
    
    // 归档结束.
    [archiver finishEncoding];
    
    // 写入本地（@"offlinedata/userId/FileManagerStore" 是写入的文件名）.
    NSString *filePath = [fileDir stringByAppendingPathComponent:@"FileManagerStore"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (!existed) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    return isSuccess;
}

// 获取存储文件
- (NSDictionary *)getManagerDic
{
    // 从本地（@"FileManagerStore" 文件中）获取.
    NSString *fileDir = [self userDirectory];
    NSString *filePath = [fileDir stringByAppendingPathComponent:@"FileManagerStore"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (existed) {
        // data.
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        // 反归档.
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        // 获取@"model" 所对应的数据
        NSDictionary *managerDic = [unarchiver decodeObjectForKey:@"FileManagerDic"];
        
        // 反归档结束.
        [unarchiver finishDecoding];
        
        if (managerDic) {
            return managerDic;
        }
        return nil;
    }
    
    return nil;
}

/** 获取 对应存储类型 数组 */
- (NSMutableArray *)getFileArrWith:(StorageType)fileType
{
    // 从本地（@"FileManagerStore" 文件中）获取.
    NSString *fileDir = [self userDirectory];
    NSString *filePath = [fileDir stringByAppendingPathComponent:@"FileManagerStore"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (existed) {
        // data.
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        // 反归档.
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        // 获取@"model" 所对应的数据
        NSDictionary *managerDic = [unarchiver decodeObjectForKey:@"FileManagerDic"];
        
        // 反归档结束.
        [unarchiver finishDecoding];
        
        if (managerDic) {
            if (fileType == VideoPlayType) {
                return managerDic[@"videoArr"];
            } else {
                return managerDic[@"keynoteArr"];
            }
        }
        return nil;
    }
    return nil;
}

// 保存文件
- (BOOL)writeToFileWith:(NSMutableArray *)storeArr and:(StorageType)fileType
{
    NSString *fileDir = [self userDirectory];
    NSDictionary *managerDic = [self getManagerDic];
    if (fileType == VideoPlayType) {
        NSMutableArray *tempArr = managerDic[@"videoArr"];
        [tempArr removeAllObjects];
        for (NSArray *arr in storeArr) {
            [tempArr addObjectsFromArray:arr];
        }
    } else {
        NSMutableArray *tempArr = managerDic[@"keynoteArr"];
        [tempArr removeAllObjects];
        [tempArr addObjectsFromArray:storeArr];
    }
    
    // 创建归档时所需的data 对象.
    NSMutableData *data = [NSMutableData data];
    
    // 归档类.
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    // 开始归档（@"model" 是key值，也就是通过这个标识来找到写入的对象）.
    [archiver encodeObject:managerDic forKey:@"FileManagerDic"];
    
    // 归档结束.
    [archiver finishEncoding];
    
    // 写入本地（@"offlinedata/userId/FileManagerStore" 是写入的文件名）.
    NSString *filePath = [fileDir stringByAppendingPathComponent:@"FileManagerStore"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if (!existed) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    BOOL isSuccess = [data writeToFile:filePath atomically:YES];
    return isSuccess;
}

// 删除文件
- (void)removeFileFrom:(NSMutableArray *)removeArr
{
    // 删除的文件
    for (DownloadLocalModel *downloadModel in removeArr) {
        NSString *allPath = downloadModel.filePath;
        NSRange range = [allPath rangeOfString:@"Documents/"];
        NSString *partPath = [allPath substringFromIndex:(range.length+range.location)];
        NSLog(@"partPath:%@",partPath);
        partPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:partPath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExist = [fileManager fileExistsAtPath:partPath];
        NSError *error = nil;
        if (fileExist) {
            BOOL deleState = [fileManager removeItemAtPath:partPath error:&error];
            NSLog(@"deleState:%d error:%@",deleState,error);
        }
    }
}

// 获取视频列表
- (NSMutableArray *)getVideoItemsList
{
    NSMutableArray *videoList = [self getFileArrWith:VideoPlayType];
    return [self sortVideoList:videoList];
}

// 将视频列表转换为标准列表
- (NSMutableArray *)sortVideoList:(NSArray *)videoList
{
    NSMutableArray *sortListArr = [NSMutableArray arrayWithCapacity:10];
    NSMutableSet *videoTypeName = [NSMutableSet setWithCapacity:5];
    for (int i = 0; i<[videoList count]; i++) {
        DownloadLocalModel *model = videoList[i];
        [videoTypeName addObject:model.courseName];
    }
    for (NSString *courseName in videoTypeName) {
        NSMutableArray *courseList = [NSMutableArray arrayWithCapacity:10];
        for (DownloadLocalModel *model in videoList) {
            if ([model.courseName isEqualToString:courseName]) {
                [courseList addObject:model];
            }
        }
        [sortListArr addObject:courseList];
    }
    return sortListArr;
}

@end
