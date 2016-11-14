//
//  ShareThirdView.m
//  WinLesson
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "ShareThirdView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

@implementation ShareThirdView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = COLOR_FontDeepBlack;
    self.contentView.backgroundColor = COLOR_TableViewBG;
    for (int i = 5000; i<5005; i++) {
        UIView *view = [self.contentView viewWithTag:i];
        view.backgroundColor = COLOR_TableViewBG;
        UILabel *label = [self.contentView viewWithTag:(i+200)];
        label.textColor = COLOR_FontTintBlack;
    }
    
    
    NSMutableArray *thirdShareArr = [NSMutableArray arrayWithCapacity:3];
    [thirdShareArr addObject:@"新浪微博"];
    // 判断是否有第三方登录 安装，没有安装则不显示
    BOOL WXinstalled =  [WXApi isWXAppInstalled];
    BOOL QQinstalled = [TencentOAuth iphoneQQInstalled];
    
    if (WXinstalled) {
        [thirdShareArr addObject:@"微信好友"];
        [thirdShareArr addObject:@"微信朋友圈"];
    }
    if (QQinstalled) {
        [thirdShareArr addObject:@"QQ好友"];
        [thirdShareArr addObject:@"QQ空间"];
    }
    [self handleViewWith:thirdShareArr];
}

- (void)handleViewWith:(NSArray *)thirdArr
{
    if (thirdArr.count == 1) {
        // 只有微博
        for (int i = 5000; i<5005; i++) {
            if (i == 5001) {
                self.imageView2.image = ImageNamed(@"新浪微博");
                self.nameLabel2.text = @"新浪微博";
                self.thirdShareViewArr = @[self.thirdView2];
                self.cellHeight = 366 - 86;
                continue;
            }
            UIView *view = [self.contentView viewWithTag:i];
            view.hidden = YES;
        }
    } else if (thirdArr.count == 3) {
        for (int i = 5000; i<5005; i++) {
            switch (i) {
                case 5000:
                {
                    self.imageView1.image = ImageNamed(@"新浪微博");
                    self.nameLabel1.text = @"新浪微博";
                }
                    break;
                case 5001:
                {
                    if ([thirdArr[1] isEqualToString:@"微信好友"]) {
                        self.imageView2.image = ImageNamed(@"微信好友");
                        self.nameLabel2.text = @"微信好友";
                    }else{
                        self.imageView2.image = ImageNamed(@"qq好友");
                        self.nameLabel2.text = @"QQ好友";
                    }
                }
                    break;
                case 5002:
                {
                    if ([thirdArr[2] isEqualToString:@"微信朋友圈"]) {
                        self.imageView3.image = ImageNamed(@"微信朋友圈");
                        self.nameLabel3.text = @"微信朋友圈";
                    }else{
                        self.imageView3.image = ImageNamed(@"QQ空间");
                        self.nameLabel3.text = @"QQ空间";
                    }
                }
                    break;
                    
                default:
                {
                    UIView *view = [self.contentView viewWithTag:i];
                    view.hidden = YES;
                }
                    break;
            }
        }
        self.thirdShareViewArr = @[self.thirdView1,self.thirdView2,self.thirdView3];
        self.cellHeight = 366 - 86;
    } else {
        self.cellHeight = 366;
        NSArray *imageArr = @[@"新浪微博",@"微信好友",@"微信朋友圈",@"qq好友",@"QQ空间"];
        for (int i = 5000; i<5005; i++) {
            UIImageView *imageView = [self.contentView viewWithTag:(i+100)];
            imageView.image = ImageNamed(imageArr[i-5000]);
            UILabel *label = [self.contentView viewWithTag:(i+200)];
            label.text = thirdArr[i-5000];
        }
        self.thirdShareViewArr = @[self.thirdView1,self.thirdView2,self.thirdView3,self.thirdView4,self.thirdView5];
    }
    
    if (IPad) {
        CGRect cellFrame = self.frame;
        self.frame = CGRectMake((SCREEN_WIDTH-375)/2, cellFrame.origin.y, 375, self.cellHeight);
        NSDictionary *attributeDic = @{CornerRadius:@(6.0),BorderColor:COLOR_LINE,BorderWidth:@(0.6)};
        [self RoundedLayerWithAttributeDic:attributeDic];
    }else{
        CGRect cellFrame = self.frame;
        self.frame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y, SCREEN_WIDTH, self.cellHeight);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
