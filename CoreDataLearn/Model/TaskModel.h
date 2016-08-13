//
//  TaskModel.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/8/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *destinationPath;
@property(nonatomic,assign)CGFloat progress;

+(instancetype)model;

@end
