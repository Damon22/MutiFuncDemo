//
//  PayBottomCell.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/29.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "PayBottomCell.h"
#import "GlobalUtil.h"

@implementation PayBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceLabel.textColor = COLOR_FontRed;
    self.boughtStatusLabel.textColor = COLOR_FontDeepBlack;
    self.line.backgroundColor = COLOR_LINE;
    self.lineHeight.constant = 0.5f;
    
    [self.signUpButtom setBackgroundColor:NavDefaultColor];
    NSDictionary *attributeDic = @{CornerRadius:@(14.0),BorderColor:NavDefaultColor,BorderWidth:@(0.01)};
    [self.signUpButtom RoundedLayerWithAttributeDic:attributeDic];
   
    self.priceToY.constant = -1.f;
    if (IPad) {
        self.priceLabelLeft.constant = 50.f;
        self.signUpButtonRight.constant =  70.f;
        self.priceStatusLabelsWidth.constant = 40.f;
    } else {
        if (IPHONE_Small6) {
            self.signUpButtonRight.constant = 20.f;
        }
    }
    
    // 初始化frame
    CGRect cellFrame = self.frame;
    self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, cellFrame.size.height);
}

/** 已经报过名 */
- (void)haveSignUp:(NSString *)btnTitle
{
    [self.signUpButtom setBackgroundColor:COLOR_placeholder];
    NSDictionary *attributeDic = @{CornerRadius:@(14.0),BorderColor:COLOR_placeholder,BorderWidth:@(0.01)};
    [self.signUpButtom RoundedLayerWithAttributeDic:attributeDic];
    [self.signUpButtom setTitle:btnTitle forState:UIControlStateNormal];
    self.signUpButtom.userInteractionEnabled = NO;
}

/** 给cell添加 价格 和 销售量 */
- (void)cellWithPrice:(CGFloat)price andSaleNum:(NSInteger)saleNum
{
    // 价格
    NSString *priceStr = [GlobalUtil getMoneyString:price];
    if ([priceStr isEqualToString:@"0"] || [priceStr isEqualToString:@"0.00"]) {
        self.priceLabel.text = @"限免";
        self.priceToY.constant = 0.f;
    }else{
        NSString *priceString = [NSString stringWithFormat:@"¥ %@",priceStr];
        NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:priceString];
        NSRange unitRange = NSMakeRange(0, 2);
        NSRange priceRange = NSMakeRange(2, [priceAttribute length]-2);
        [priceAttribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] range:unitRange];
        [priceAttribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:23],NSFontAttributeName, nil] range:priceRange];
        self.priceLabel.attributedText = priceAttribute;
        //[UIFont fontWithName:NumberFont size:23]
        CGSize size =[priceString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:23]}];
        self.priceWidth.constant = ceil(size.width)-5;
    }
    
    // 购买数
    self.boughtStatusLabel.text = [NSString stringWithFormat:@"已有%ld人购买",(long)saleNum];
}

- (void)dealloc
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
