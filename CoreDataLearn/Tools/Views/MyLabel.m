//
//  MyLabel.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/28.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

@synthesize verticalAlignment = verticalAlignment_;
@synthesize isPlaceHolder = _isPlaceHolder;
@synthesize hidden = _hidden;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setIsPlaceHolder:(BOOL)isPlaceHolder
{
    _isPlaceHolder = isPlaceHolder;
    if (_isPlaceHolder) {
        NSString *textInfo = self.text;
        self.text = nil;
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:textInfo];
        NSRange tempRange = [textInfo rangeOfString:@"（"];
        if (tempRange.location == NSNotFound) {
            // 没有（）
            NSRange titleRange = NSMakeRange(0, attributeStr.length);
            [attributeStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] range:titleRange];
            self.attributedText = attributeStr;
        } else {
            NSRange titleRange = NSMakeRange(0, tempRange.location-1);
            NSRange subRange = NSMakeRange(tempRange.location, textInfo.length-tempRange.location);
            [attributeStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] range:titleRange];
            [attributeStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] range:subRange];
            self.attributedText = attributeStr;
        }
    }
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
}

@end
