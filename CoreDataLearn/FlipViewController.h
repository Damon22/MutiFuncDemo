//
//  FlipViewController.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnimationDelegate;
@interface FlipViewController : UIViewController <UIGestureRecognizerDelegate> {
    AnimationDelegate *animationDelegate;
    AnimationDelegate *animationDelegateR;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *flipView;

@property (weak, nonatomic) IBOutlet UIView *flipViewR;

@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizerR;

- (void)panned:(UIPanGestureRecognizer *)recognizer;

@end
