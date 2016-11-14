//
//  BaseChatViewController.h
//  WinLesson
//
//  Created by 高继鹏 on 16/8/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "CommonBaseViewController.h"

@class FBKVOController;

@interface BaseChatViewController : CommonBaseViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)callImagePickerActionSheet;

// 对于界面上有输入框的，可以选择性调用些方法进行收起键盘
- (void)addTapBlankToHideKeyboardGesture;

@end
