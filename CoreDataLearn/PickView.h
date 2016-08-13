//
//  PickView.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerViewDataSource;

@end
