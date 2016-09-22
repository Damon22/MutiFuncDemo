//
//  DirectionMPMoviePlayerViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/9/20.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "DirectionMPMoviePlayerViewController.h"

@implementation DirectionMPMoviePlayerViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UIDeviceOrientation deviceOrientation = UIDeviceOrientationUnknown;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            deviceOrientation = UIDeviceOrientationUnknown;
            break;
        case UIDeviceOrientationPortrait:
            deviceOrientation = UIDeviceOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeRight:
            deviceOrientation = UIDeviceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeLeft:
            deviceOrientation = UIDeviceOrientationLandscapeLeft;
            break;
            
        default:
            break;
    }
    return UIDeviceOrientationIsLandscape(deviceOrientation);
}

@end
