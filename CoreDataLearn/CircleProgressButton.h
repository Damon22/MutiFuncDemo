//
//  CircleProgressButton.h
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/9/12.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleProgressButtonDelegate <NSObject>

@optional
- (void)updateProgressViewWithProgress:(float)progress;

@end

@interface CircleProgressButton : UIButton

@property (nonatomic, assign) float progress;
@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) id <CircleProgressButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;

- (void)setProgress:(float)progress;

@end
