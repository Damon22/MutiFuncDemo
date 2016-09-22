//
//  DownloadPlayViewController.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 2016/9/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadPlayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *downloadArr;

@end
