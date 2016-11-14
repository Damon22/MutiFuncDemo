//
//  UIImage+size.h
//  必胜课
//
//  Created by Damon on 15/10/28.
//  Copyright © 2015年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (size)
//对图片尺寸进行压缩--
- (UIImage *)imageScaledToSize:(CGSize)newSize;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
@end
