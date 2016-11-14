//
//  QuickItem.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/17.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface QuickItem : NSObject <QLPreviewItem>

@property (nonatomic, strong) NSString *currentTitle;
@property (nonatomic, strong) NSString *path;
@property (readonly) NSString *previewItemTitle;
@property (readonly) NSURL *previewItemURL;

@end
