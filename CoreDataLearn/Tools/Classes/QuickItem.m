//
//  QuickItem.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/17.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "QuickItem.h"

@implementation QuickItem

- (NSString *)previewItemTitle
{
    if (!_currentTitle) {
        return [_path lastPathComponent];
    }
    return _currentTitle;
}

- (NSURL *)previewItemURL
{
    return [NSURL fileURLWithPath:_path];
}

@end
