//
//  TestDataViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/7/18.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "TestDataViewController.h"

@interface TestDataViewController ()

@end

@implementation TestDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSStringEncoding gbkEncoding =
    CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *name = @"2cfe8074ffc856edf121698f2760f027";
    NSString *finalPath = [path stringByAppendingPathComponent:name];
    NSData *fileData = [NSData dataWithContentsOfFile:finalPath];
    NSString *aString = [[NSString alloc] initWithData:fileData encoding:gbkEncoding];
    NSLog(@"aString:%@",aString);
    
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
