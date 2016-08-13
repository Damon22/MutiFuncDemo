//
//  PickViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/21.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController () <UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *pickView;
    NSMutableArray *pickViewDataSource;
}
/** 定时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation PickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    pickViewDataSource = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1; i<11; i++) {
        [pickViewDataSource addObject:[NSString stringWithFormat:@"%d分",i*10]];
    }
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(100, 100, 70, 70)];
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.showsSelectionIndicator = YES;
    [pickView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:pickView];
    [pickView selectRow:[pickViewDataSource count] inComponent:0 animated:YES];
    
    [self setupTimer];
}

#pragma mark pickview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickViewDataSource count]*50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickViewDataSource objectAtIndex:(row%[pickViewDataSource count])];
}

//选中picker cell,save ArrayIndex
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self stopTimer];
    NSUInteger max = 0;
    NSUInteger base10 = 0;
    if(component == 0)
    {
        max = [pickViewDataSource count]*50;
        base10 = (max/2)-(max/2)%[pickViewDataSource count];
        [pickerView selectRow:[pickerView selectedRowInComponent:component]%[pickViewDataSource count]+base10 inComponent:component animated:false];
    }
    [self setupTimer];
}

//替换text居中
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [pickViewDataSource objectAtIndex:(row%[pickViewDataSource count])];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)addRowInCOmponent
{
    NSInteger currentRow = [pickView selectedRowInComponent:0];
    NSLog(@"currentRow:%ld",currentRow);
    NSUInteger max = [pickViewDataSource count]*50;
    NSUInteger base10 = (max/2)-(max/2)%[pickViewDataSource count];
    if ([pickView selectedRowInComponent:0]%[pickViewDataSource count]+base10+1>=base10+10) {
        [pickView selectRow:base10 inComponent:0 animated:false];
    }else{
        [pickView selectRow:[pickView selectedRowInComponent:0]%[pickViewDataSource count]+base10+1 inComponent:0 animated:false];
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
