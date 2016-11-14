//
//  UIView+nice.m
//  必胜课
//
//  Created by Damon on 15/8/24.
//  Copyright (c) 2015年 Damon. All rights reserved.
//

#import "UIView+nice.h"

@implementation UIView (nice)

-(void)RoundedLayerWithCornerRadius:(CGFloat)radius andBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width
{
//    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}

/** 对圆锯齿优化，性能有影响 */
-(void)RoundedBatterLayerWithCornerRadius:(CGFloat)radius andBorderColor:(UIColor *)color andBorderWidth:(CGFloat)width
{
    //    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = radius;
    self.layer.shadowColor = NavDefaultColor.CGColor;
    self.layer.allowsEdgeAntialiasing = YES;
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge|kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.layer.masksToBounds = YES;
}

//给某些UIView加圆角边框,圆角边框的属性存在attributeDic中
-(void)RoundedLayerWithAttributeDic:(NSDictionary *)attributeDic
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = [attributeDic[CornerRadius] floatValue];
    self.layer.borderColor = ((UIColor *)attributeDic[BorderColor]).CGColor;
    self.layer.borderWidth = [attributeDic[BorderWidth] floatValue];
}

//给lable或textView的内容加行间距
-(void)lineSpacing:(CGFloat)spacing
{
    if ([self.class isSubclassOfClass:[UILabel class]]) {
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:((UILabel *)self).text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [((UILabel *)self).text length])];
        [((UILabel *)self) setAttributedText:attributedString];
        [((UILabel *)self) sizeToFit];
    }else if ([self.class isSubclassOfClass:[UITextView class]]) {
        
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:((UITextView *)self).text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [((UITextView *)self).text length])];
        [((UITextView *)self) setAttributedText:attributedString];
        [((UITextView *)self) sizeToFit];
    }else if ([self.class isSubclassOfClass:[UITextField class]]){
        
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
