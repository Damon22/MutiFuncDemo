//
//  InputChatView.h
//  WinLesson
//
//  Created by 高继鹏 on 16/8/31.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputChatView : UITableViewCell
{
@protected
    __weak id<ChatInputAbleViewDelegate> _chatDelegate;
    
@protected
    __weak UIView<ChatInputAbleView> *_panel;
    
@protected
    NSInteger   _contentHeight;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *showTitleImage;

@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
/** 提示语 */
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (nonatomic, strong) UIView *upLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;

@property (nonatomic, weak) id<ChatInputAbleViewDelegate> chatDelegate;
@property (nonatomic, assign) NSInteger contentHeight;

- (BOOL)isEditing;

- (void)setInputText:(NSString *)text;

@end
