//
//  UIView+LineSpace.m
//  guideBook
//
//  Created by 上官惠阳 on 15/12/30.
//  Copyright © 2015年 上官惠阳. All rights reserved.
//

#import "UIView+LineSpace.h"

@implementation UIView (LineSpace)
//给lable或textView的内容加行间距
- (void)lineSpacing:(CGFloat)spacing
{
    if ([self.class isSubclassOfClass:[UILabel class]]) {
        if (!((UILabel *)self).text) {
            return;
        }
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:((UILabel *)self).text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [((UILabel *)self).text length])];
        [((UILabel *)self) setAttributedText:attributedString];
        [((UILabel *)self) sizeToFit];
    }else if ([self.class isSubclassOfClass:[UITextView class]]) {
        if (!((UITextView *)self).text) {
            return;
        }
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:((UITextView *)self).text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [((UITextView *)self).text length])];
        [((UITextView *)self) setAttributedText:attributedString];
        [((UITextView *)self) sizeToFit];
    }else if ([self.class isSubclassOfClass:[UITextField class]]){
        if (!((UITextField *)self).text) {
            return;
        }
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:((UITextField *)self).text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [((UITextField *)self).text length])];
        [((UITextField *)self) setAttributedText:attributedString];
        [((UITextField *)self) sizeToFit];
    }else{
        return;
    }
}
@end
