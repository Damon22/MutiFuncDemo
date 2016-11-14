//
//  SubjectHtmlParser.h
//  WinLesson
//
//  Created by 高继鹏 on 16/7/18.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamItemHelper.h"

@interface SubjectHtmlParser : NSObject

@property (nonatomic, strong) NSMutableArray *subjectsArr;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, assign) NSUInteger subjectsCount;    // 题目个数

+ (instancetype)shareHtmlParser;

/** 解析返回的题目信息 */
/**
 格式信息：
 @[ // 多道题
    @[ // 单道题
        @{
            subject:@[题目]
            item:@[@选项1,@选项2,@选项3]
            analysis:@[解析]
            material:@[材料]
        }
    ]
 ]
 */
- (NSArray *)parserHTMLWith:(NSArray *)subjectInfoList;

/** 下载试卷里的图片 */
- (void)downloadSubjectImages;

/** 获取存储的照片文件 */
+ (UIImage *)getInputImage:(NSString *)imageName;

@end
