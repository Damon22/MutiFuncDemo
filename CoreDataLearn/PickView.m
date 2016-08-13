//
//  PickView.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "PickView.h"

@interface PickView ()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 定时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation PickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTimer];
    }
    return self;
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_pickerView];
        [_pickerView selectRow:[self.pickerViewDataSource count] inComponent:0 animated:YES];
    }
    return _pickerView;
}

//- (void)drawRect:(CGRect)rect {
//    
//}

#pragma mark pickview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerViewDataSource count]*50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerViewDataSource objectAtIndex:(row%[_pickerViewDataSource count])];
}

//选中picker cell,save ArrayIndex
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self stopTimer];
    NSUInteger max = 0;
    NSUInteger base10 = 0;
    if(component == 0)
    {
        max = [_pickerViewDataSource count]*50;
        base10 = (max/2)-(max/2)%[_pickerViewDataSource count];
        [pickerView selectRow:[pickerView selectedRowInComponent:component]%[_pickerViewDataSource count]+base10 inComponent:component animated:false];
    }
    [self setupTimer];
}

//替换text居中
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [_pickerViewDataSource objectAtIndex:(row%[_pickerViewDataSource count])];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)addRowInCOmponent
{
    NSInteger currentRow = [self.pickerView selectedRowInComponent:0];
    NSLog(@"currentRow:%ld",currentRow);
    NSUInteger max = [_pickerViewDataSource count]*50;
    NSUInteger base10 = (max/2)-(max/2)%[_pickerViewDataSource count];
    if ([self.pickerView selectedRowInComponent:0]%[_pickerViewDataSource count]+base10+1>=base10+10) {
        [self.pickerView selectRow:base10 inComponent:0 animated:false];
    }else{
        [self.pickerView selectRow:[self.pickerView selectedRowInComponent:0]%[_pickerViewDataSource count]+base10+1 inComponent:0 animated:false];
    }
}

- (void)setupTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(addRowInCOmponent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

#pragma mark 删除定时器
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
