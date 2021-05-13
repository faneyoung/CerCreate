//
//  ZXSDHomeJoinedPeopleCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeJoinedPeopleCell.h"

@interface ZXSDHomeJoinedPeopleCell ()

@property (nonatomic, strong) UILabel *tips;

@end

@implementation ZXSDHomeJoinedPeopleCell


- (void)setRenderData:(id)renderData
{
    /*
    if (![renderData isKindOfClass:[ZXSDHomeLoanInfo class]]) {
        return;
    }
    
    ZXSDHomeLoanInfo *model = renderData;
    self.tips.text = [NSString stringWithFormat:@"已有 %@ 人加入了薪朋友", @(model.extraInfo.userSum)];
    
    NSDictionary * underAttribtDic  = @{
        NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
        NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x00C35A), NSFontAttributeName:FONT_PINGFANG_X(16)};
    NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:self.tips.text];
    [underAttr addAttributes:underAttribtDic
                       range:NSMakeRange(3, @(model.extraInfo.userSum).stringValue.length)];
    
    self.tips.attributedText = underAttr;*/
    
    //self.tips.text = @"邀请我的同事，得现金红包";
    
}

- (void)initView
{
    UIImageView *banner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_home_joinedbg"]];
    banner.userInteractionEnabled = YES;
    [self.contentView addSubview:banner];
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
    
    [banner addSubview:self.tips];
    [self.tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(banner).offset(4);
        make.centerX.equalTo(banner).offset(20);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClicked)];
    [banner addGestureRecognizer:tap];
}

- (void)bannerClicked
{
    if (self.bannerAction) {
        self.bannerAction();
    }
}

- (UILabel *)tips
{
    if (!_tips) {
        _tips = [UILabel labelWithText:@"" textColor:kThemeColorMain font:FONT_PINGFANG_X(16)];
        _tips.textAlignment = NSTextAlignmentCenter;
    }
    return _tips;
}

@end
