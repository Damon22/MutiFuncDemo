//
//  CircleAnimationView.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/2.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleAnimationView : UIView {
    CGRect ball;
    float velx;
    float vely;
}

- (void)moveBall;

@end
