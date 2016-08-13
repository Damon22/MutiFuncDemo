//
//  DownloadInfoCell.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseCircleView;
@class TaskModel;
@interface DownloadInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BaseCircleView *CircleStatusView;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property(nonatomic,copy)void (^downloadBlock)(BaseCircleView *currentStatusView);

-(void)cellWithModel:(TaskModel *)model;

@end
