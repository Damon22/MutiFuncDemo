//
//  UIKitDemoViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/7/30.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "UIKitDemoViewController.h"
#import "FlowerView.h"
#import "FlowerTransformView.h"
#import "CircleAnimationView.h"
#import "MoveBallView.h"
#import "TouchCGView.h"

@interface UIKitDemoViewController ()

@end

@implementation UIKitDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    FlowerView *flowerView = [[FlowerView alloc] initWithFrame:CGRectMake(0, 0, 320, 567)];
//    [self.view addSubview:flowerView];
    
//    FlowerTransformView *flowerTransformView = [[FlowerTransformView alloc] initWithFrame:CGRectMake(0, 0, 320, 567)];
//    [self.view addSubview:flowerTransformView];
    
    CircleAnimationView *circleView = [[CircleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 320, 567)];
    [self.view addSubview:circleView];
    
//    TouchCGView *touchView = [[TouchCGView alloc] initWithFrame:CGRectMake(0, 0, 320, 567)];
//    [self.view addSubview:touchView];
//    
//    MoveBallView *moveBallView = [[MoveBallView alloc] initWithFrame:CGRectMake(0, 0, 320, 567)];
//    [self.view addSubview:moveBallView];
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
