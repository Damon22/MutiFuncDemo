//
//  FlipViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "FlipViewController.h"
#import "FlipView.h"
#import "AnimationDelegate.h"

@interface FlipViewController ()

@property (nonatomic, strong) FlipView *fpView;
@property (nonatomic, strong) FlipView *fpViewR;
@property (nonatomic, assign) BOOL panIncrease;
@property (nonatomic, assign) BOOL panDecrease;

@end

@implementation FlipViewController
@synthesize panRecognizer, panRecognizerR;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _panIncrease = NO;
    _panDecrease = NO;
    
    animationDelegate = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto directionType:kDirectionForward];
    animationDelegate.controller = self;
    animationDelegate.perspectiveDepth = 500;
    animationDelegate.nextDuration = 2.0f;
    animationDelegate.repeatDelay = 2.0f;
    animationDelegate.shadow = NO;
    animationDelegate.sensitivity = 100;
    _fpView = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical frame:CGRectMake(0, 0, self.flipView.frame.size.width, self.flipView.frame.size.height)];
    animationDelegate.transformView = self.fpView;
    [self.flipView addSubview:self.fpView];
    
    self.fpView.fontSize = 30;
    self.fpView.font = @"System";
    self.fpView.fontAlignment = @"center";
    self.fpView.textOffset = CGPointMake(0, self.flipView.frame.size.height/2-15);
    self.fpView.textTruncationMode = kCATruncationEnd;
    self.fpView.sublayerCornerRadius = 0.0f;
    self.fpView.backgroundColor = [UIColor redColor];
    
    for (int i = 10; i > 0; i--) {
        [self.fpView printText:[NSString stringWithFormat:@"%d",i*10] usingImage:nil backgroundColor:[UIColor whiteColor] textColor:[UIColor blackColor]];
    }
    
    [animationDelegate startAnimation:kDirectionForward];
    animationDelegate.repeat = YES;
    
    
    animationDelegateR = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto directionType:kDirectionForward];
    animationDelegateR.controller = self;
    animationDelegateR.perspectiveDepth = 500;
    animationDelegateR.nextDuration = 2.0f;
    animationDelegateR.repeatDelay = 2.0f;
    animationDelegateR.shadow = NO;
    animationDelegateR.sensitivity = 100;
    _fpViewR = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical frame:CGRectMake(0, 0, self.flipViewR.frame.size.width, self.flipViewR.frame.size.height)];
    animationDelegateR.transformView = self.fpViewR;
    [self.flipViewR addSubview:self.fpViewR];
    
    self.fpViewR.fontSize = 30;
    self.fpViewR.font = @"System";
    self.fpViewR.fontAlignment = @"center";
    self.fpViewR.textOffset = CGPointMake(0, self.flipViewR.frame.size.height/2-15);
    self.fpViewR.textTruncationMode = kCATruncationEnd;
    self.fpViewR.sublayerCornerRadius = 0.0f;
    self.fpViewR.backgroundColor = [UIColor redColor];
    
    for (int i = 10; i > 0; i--) {
        [self.fpViewR printText:[NSString stringWithFormat:@"%d题",20+i] usingImage:nil backgroundColor:[UIColor whiteColor] textColor:[UIColor blackColor]];
    }
    
    [animationDelegateR startAnimation:kDirectionForward];
    animationDelegateR.repeat = YES;
    
    
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panRecognizer.delegate = self;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    [self.fpView addGestureRecognizer:panRecognizer];
    
    self.panRecognizerR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panRecognizerR.delegate = self;
    panRecognizerR.maximumNumberOfTouches = 1;
    panRecognizerR.minimumNumberOfTouches = 1;
    [self.fpViewR addGestureRecognizer:panRecognizerR];
    
}

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded))
    {
        CGPoint velocity = [recognizer velocityInView:self.view];
        
        if (velocity.y >0)   // panning down
        {
//            NSLog (@"Decreasing brigntness in pan");
            _panDecrease = YES;
        }
        else                // panning up
        {
//            NSLog (@"Increasing brigntness in pan");
            _panIncrease = YES;
        }
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
            //        case UIGestureRecognizerStateRecognized: // for discrete recognizers
            //            break;
        case UIGestureRecognizerStateFailed: // cannot recognize for multi touch sequence
            break;
        case UIGestureRecognizerStateBegan: {
            // allow controlled flip only when touch begins within the pan region
//            if (CGRectContainsPoint(self.bottomView.frame, [recognizer locationInView:self.bottomView]) || CGRectContainsPoint(self.bottomView.frame, [recognizer locationInView:self.bottomView])) {
//                
//            }
            if (animationDelegate.animationState == 0 || animationDelegateR.animationState == 0) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                animationDelegate.sequenceType = kSequenceControlled;
                animationDelegate.animationLock = YES;
                animationDelegateR.sequenceType = kSequenceControlled;
                animationDelegateR.animationLock = YES;
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (animationDelegate.animationLock||animationDelegateR.animationLock) {
                float value = [recognizer translationInView:self.view].y;
                [animationDelegate setTransformValue:value delegating:NO];
                [animationDelegateR setTransformValue:value delegating:NO];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled: // cancellation touch
            break;
        case UIGestureRecognizerStateEnded: {
            if (animationDelegate.animationLock || animationDelegateR.animationLock) {
                // provide inertia to panning gesture
                float value = sqrtf(fabs([recognizer velocityInView:self.view].x))/10.0f;
                [animationDelegate endStateWithSpeed:value];
                animationDelegate.sequenceType = kSequenceAuto;
                animationDelegate.animationLock = NO;
                [animationDelegateR endStateWithSpeed:value];
                animationDelegateR.sequenceType = kSequenceAuto;
                animationDelegateR.animationLock = NO;
            }
            if (_panIncrease) {
                [self performSelector:@selector(delayAnimation) withObject:nil afterDelay:1.0f];
            }
            _panIncrease = NO;
            _panDecrease = NO;
        }
            break;
        default:
            break;
    }
}

- (void)delayAnimation
{
    [animationDelegate endStateWithSpeed:10.0];
    [animationDelegate resetTransformValues];
    [animationDelegate startAnimation:kDirectionForward];
    animationDelegate.perspectiveDepth = 500;
    animationDelegate.nextDuration = 2.0f;
    animationDelegate.repeatDelay = 2.0f;
    [animationDelegateR endStateWithSpeed:10.0];
    [animationDelegateR resetTransformValues];
    [animationDelegateR startAnimation:kDirectionForward];
    animationDelegateR.perspectiveDepth = 500;
    animationDelegateR.nextDuration = 2.0f;
    animationDelegateR.repeatDelay = 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
