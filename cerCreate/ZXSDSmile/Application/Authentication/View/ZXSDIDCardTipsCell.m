//
//  ZXSDIDCardTipsCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDIDCardTipsCell.h"

@implementation ZXSDIDCardTipsCell

- (void)initView
{
    UILabel *promptTitleLabel = [UILabel labelWithText:@"拍摄提示" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:promptTitleLabel];
    [promptTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *promptContentLabel = [UILabel labelWithText:@"1.  请确保身份证边框清晰完整，背景干净无反光；\n2.  确保身份证未过期并与开户本人一致；\n3.  请使用身份证原件，不要使用复印件。" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    promptContentLabel.numberOfLines = 0;
    [self.contentView addSubview:promptContentLabel];
    [promptContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(10);
        make.top.equalTo(promptTitleLabel.mas_bottom).offset(16);
//        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    UILabel *modifyTitleLab = [UILabel labelWithText:@"更改提示" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:modifyTitleLab];
    [modifyTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(promptContentLabel.mas_bottom).inset(20);
        make.left.inset(20);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *modifyTipLab = [UILabel labelWithText:@"对于以上身份信息中有识别错误的情况，请手动输入正确信息完成更改，否则会影响之后的验证流程" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    modifyTipLab.numberOfLines = 0;
    [self.contentView addSubview:modifyTipLab];
    [modifyTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.top.equalTo(modifyTitleLab.mas_bottom).inset(10);
//        make.bottom.inset(20);
    }];


}

@end
