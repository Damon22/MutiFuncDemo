//
//  MyLabel.h
//  WinLesson
//
//  Created by 高继鹏 on 16/6/28.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,VerticalAlignment) {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface MyLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

// 是否是 前面大，后面小的字体
@property (nonatomic) BOOL isPlaceHolder;

@property (nonatomic) BOOL hidden;


@end
