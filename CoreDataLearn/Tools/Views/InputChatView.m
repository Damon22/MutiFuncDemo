//
//  InputChatView.m
//  WinLesson
//
//  Created by 高继鹏 on 16/8/31.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "InputChatView.h"

#define kButtonSize 36
#define kTextViewMaxHeight 72
#define kVerMargin 7

@interface InputChatView () <UITextViewDelegate, ChatInputAbleView>

@end

@implementation InputChatView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 上边线
    self.upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    self.upLine.backgroundColor = COLOR_LINE;
    [self addSubview:self.upLine];
    // 下边线
    self.bottomLineHeight.constant = 0.5f;
    self.bottomLine.backgroundColor = COLOR_LINE;
    self.bottomLine.hidden = YES;
    // 提示语
    self.remindLabel.textColor = COLOR_placeholder;
    self.chatTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.chatTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, cellFrame.size.height);
    
    self.chatTextView.delegate = self;
    
    _contentHeight = 50;
}

- (BOOL)isEditing
{
    return [self.chatTextView isFirstResponder];
}

- (void)setInputText:(NSString *)text
{
    _chatTextView.text = text;
}

#pragma mark- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([_chatDelegate respondsToSelector:@selector(onChatInput:sendMsg:)])
        {
            if (textView.text.length > 0)
            {
                IMAMsg *msg = [IMAMsg msgWithText:textView.text];
                [_chatDelegate onChatInput:self sendMsg:msg];
            }
            self.chatTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
        }
        
        return NO;
    }
    return YES;
}

- (NSInteger)getTextViewContentH:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        return kButtonSize;
    }
    if ([IOSDeviceConfig sharedConfig].isIOS6Later)
    {
        return (NSInteger)([textView sizeThatFits:textView.bounds.size].height + 1);
    }
    else
    {
        return (NSInteger)(textView.contentSize.height + 1);
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView hasText]) {
        self.remindLabel.hidden = YES;
    }else{
        self.remindLabel.hidden = NO;
    }
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
    
    /*
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }*/
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    CGFloat textViewToHeight = toHeight;
    
    if (toHeight < kButtonSize)
    {
        textViewToHeight = kButtonSize;
    }
    
    if (toHeight > kTextViewMaxHeight)
    {
        textViewToHeight = kTextViewMaxHeight;
    }
    
    NSInteger conHeight = textViewToHeight + 2 * kVerMargin;
    if (_contentHeight != conHeight)
    {
        self.contentHeight = conHeight;
    }
    NSInteger off = self.chatTextView.contentSize.height - textViewToHeight;
    if (off > 0)
    {
        [self.chatTextView setContentOffset:CGPointMake(0, off) animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
