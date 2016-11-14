//
//  TitleInfoCell.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/16.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "TitleInfoCell.h"
#import "MyMessageModel.h"
#import "GlobalUtil.h"

@implementation TitleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineHeight.constant = 0.5f;
    self.line.backgroundColor = COLOR_LINE;
    self.cellDate.textColor = COLOR_FontTintBlack;
    self.cellInfoLabel.textColor = COLOR_FontTintBlack;
    self.cellTitle.textColor = TabBarDefaultFontColor;
    self.cellInfoLabel.hidden = YES;
    self.cellTitleLeft.constant = 16;
    self.cellDateLeft.constant = 16;
    self.cellTitle.numberOfLines = 0;
    
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, DefaultHeight);
}

/** 设置 info 内容 : @"难度4.2,共15题,你未做完" */
- (void)setInfoStr:(NSDictionary *)infoDic {
    self.cellInfoLabel.hidden = NO;
    
    if (iPhoneWidthBiggerThan5) {
        self.cellTitleLeft.constant = 23;
        self.cellDateLeft.constant = 23;
    }else{
        self.cellTitleLeft.constant = 16;
        self.cellDateLeft.constant = 16;
    }
    self.cellTitle.font = [UIFont systemFontOfSize:15];
    self.cellDate.font = [UIFont systemFontOfSize:13];
    self.cellInfoLabel.font = [UIFont systemFontOfSize:13];
    
    if (self.viewControllType == LearnRecord) {
        NSString *timeString = [NSString stringWithFormat:@"%@",infoDic[@"createTime"]];
        if ([timeString length]  > 10) {
            timeString = [timeString substringToIndex:10];
        }
        
        BOOL isFinish = ([infoDic[@"un_has_finish"] integerValue] == 0) ? NO : YES;
        NSString *difficulty = [NSString stringWithFormat:@"%.1f",[infoDic[@"difficulty"] floatValue]];
        NSString *date = [GlobalUtil getMoreCharacterDateFromString:timeString];
        NSString *totalCount = infoDic[@"subject_count"];
        NSString *correntNum = infoDic[@"subject_currentNum"];
        
        self.cellTitle.text = infoDic[@"paperName"];
        self.cellDate.text = date;
        self.cellInfoLabel.text = [NSString stringWithFormat:@"难度%@，共%@题，你未做完",difficulty,totalCount];
        if (isFinish) {
            self.cellInfoLabel.text = [NSString stringWithFormat:@"难度%@，共%@题，做对%@题",difficulty,totalCount,correntNum];
        }
    } else {
        self.cellTitle.text = infoDic[@"paperName"];
        self.cellDate.text = infoDic[@"examTime"];
        self.cellInfoLabel.text = [NSString stringWithFormat:@"共%@人参加",infoDic[@"paperCount"]];
        if ([infoDic[@"paperIsJoined"] intValue] == 0) {
            // 未参加
            self.cellInfoLabel.text = [self.cellInfoLabel.text stringByAppendingString:@"，你未参加"];
            self.cellIconImage.hidden = YES;
        }else{
            self.cellIconImage.hidden = NO;
        }
    }
}

/** 我的消息 设置 */
- (void)setCellWithModel:(MyMessageModel *)model
{
    // 标题
    self.cellTitle.text = model.messageName;
    // 时间
    NSString *timeString = [NSString stringWithFormat:@"%@",model.messageTime];
    if ([timeString length]  > 10) {
        timeString = [timeString substringToIndex:10];
    }
    self.cellDate.text = [GlobalUtil getMoreCharacterDateFromString:timeString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
