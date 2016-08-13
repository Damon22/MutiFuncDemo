//
//  MoveBallView.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveBallView : UIView {
    CGRect ball;
    float velx;
    float vely;
}

- (void)moveBall;

@end
