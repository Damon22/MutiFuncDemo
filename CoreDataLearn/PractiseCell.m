//
//  PractiseCell.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "PractiseCell.h"
#import "TableViewController2.h"

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

@implementation PractiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    self.backgroundColor = [UIColor whiteColor];
    TableViewController2 *tableVC2 = [[TableViewController2 alloc] init];
    [self.showDetailView addSubview:tableVC2.view];
}

@end
