//
//  FileManager.h
//  WinLesson
//
//  Created by 高继鹏 on 16/9/14.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^downloadSuccessBlock)(BOOL isSuccess, NSString *filePath);

typedef NS_ENUM(NSInteger, StorageType) {
    VideoPlayType,
    PDFType
};

@class TYDownloadModel;
@interface FileManager : NSObject

+ (instancetype)shareManager;

/** 根据name获取 TYDownloadModel */
- (TYDownloadModel *)modelWithDownloadName:(NSString *)name;

/** 存储TYDownLoadModel临时下载数据 */
@property (nonatomic, strong) NSMutableArray *downloadList;

/** 根据model下载讲义并返回结果
 文件名称
 下载结果
 */
- (void)getDownloadWith:(TYDownloadModel *)downloadModel
            andFileName:(NSString *)fileName
            andCourseId:(NSString *)courseId
          andCourseName:(NSString *)courseName
                 Result:(downloadSuccessBlock)successBlock;

/** 获取正确的打开路径 */
- (NSString *)getCorrectLocalPath:(NSString *)localPath;

/** 判断文件是否下载 */
- (BOOL)checkoutDownloadState:(TYDownloadModel *)downloadModel;


#pragma mark 创建文件夹
/** 创建默认的文件夹: 在刚创建的时候 就要设置
 如果有则不创建
 没有则创建
 */
- (void)defaultFilePath;

/** 创建用户的文件夹: 在用户登录后创建
 如果有则不创建
 没有则创建
 */
- (void)userDirectoryFilePath;


#pragma mark 路径
/** 文件夹默认的路径：
 [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"offlinedata"];
 */
- (NSString *)defaultDirectory;

/** 用户个人的下载文件夹路径 /defaultDirectory/userId/xxx.mp4 */
- (NSString *)userDirectory;


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
                     andType:(StorageType)type;

/** 获取 对应存储类型 数组 */
- (NSMutableArray *)getFileArrWith:(StorageType)fileType;

// 保存文件
- (BOOL)writeToFileWith:(NSMutableArray *)storeArr and:(StorageType)fileType;

// 删除文件
- (void)removeFileFrom:(NSMutableArray *)removeArr;

// 获取视频列表
- (NSMutableArray *)getVideoItemsList;

@end








