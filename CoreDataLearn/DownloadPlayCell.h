//
//  DownloadPlayCell.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 2016/9/22.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleProgressButton;
@class TYDownloadModel;
@interface DownloadPlayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (nonatomic, strong) CircleProgressButton *progressButton;
-(void)cellWithModel:(TYDownloadModel *)model;

@end
