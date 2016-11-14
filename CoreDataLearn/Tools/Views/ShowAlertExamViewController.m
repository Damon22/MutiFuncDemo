//
//  ShowAlertExamViewController.m
//  WinLesson
//
//  Created by 高继鹏 on 16/7/11.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ShowAlertExamViewController.h"
#import "AlertShowExamCell.h"

@interface ShowAlertExamViewController ()

@property (nonatomic, strong) AlertShowExamCell *alertView;

@end

@implementation ShowAlertExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_AlertBG;
    
    _alertView = [[[NSBundle mainBundle] loadNibNamed:@"AlertShowExamCell" owner:self options:nil] lastObject];
    _alertView.frame = CGRectMake((SCREEN_WIDTH-320)/2.0, (SCREEN_HEIGHT-152)/2.0, 320, 152);
    if (self.alertType == ExamAlertSubmit) {
        _alertView.infoStrLabel.text = @" 做事要善始善终哦! 你还有题目未做完\n 确定交卷吗?";
    } else if (self.alertType == ExamAlertQuiet) {
        // 退出没做完的练习
        _alertView.infoStrLabel.text = @" 做事要善始善终哦! 你还有题目未做完\n 确定要离开吗?";
    }
    [_alertView.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView.ensureBtn addTarget:self action:@selector(ensureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_alertView];
}

- (void)setAlertTitleStr:(NSString *)titleStr
{
    _alertView.infoStrLabel.text = titleStr;
    [_alertView.cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView.ensureBtn addTarget:self action:@selector(ensureAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancleAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([self.alertDelegate respondsToSelector:@selector(selectAlertLeftButton:)]) {
        [self.alertDelegate selectAlertLeftButton:sender];
    }
}

- (void)ensureAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([self.alertDelegate respondsToSelector:@selector(selectAlertRightButton:)]) {
        [self.alertDelegate selectAlertRightButton:sender];
    }
}

#pragma mark - 展示当前视图
- (void)show
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }else{
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    [self.delegate presentViewController:self animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.delegate = nil;
    self.alertDelegate = nil;
    [self.alertView removeFromSuperview];
    self.alertView = nil;
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
