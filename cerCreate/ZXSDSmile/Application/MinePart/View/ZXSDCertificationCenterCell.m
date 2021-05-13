//
//  ZXSDCertificationCenterCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCertificationCenterCell.h"

@interface ZXSDCertificationCenterCell()

@property (strong, nonatomic) UILabel *certNameLabel;
@property (strong, nonatomic) UILabel *certContentLabel;
@property (strong, nonatomic) UILabel *certStatusLabel;

@end

@implementation ZXSDCertificationCenterCell

- (void)initView
{
    [self.contentView addSubview:self.certNameLabel];
    [self.contentView addSubview:self.certContentLabel];
    [self.contentView addSubview:self.certStatusLabel];
    
    [self.certNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.certContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.certNameLabel);
        make.top.equalTo(self.certNameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.certStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDCertificationCenterModel class]]) {
        return;
    }
    
    ZXSDCertificationCenterModel *model = (ZXSDCertificationCenterModel *)renderData;
    
    self.certNameLabel.text = model.certName;
    self.certContentLabel.text = model.certContent;
    self.certStatusLabel.text = model.certDes;
    
    if ([model.certType isEqualToString:@"salaryInfo"] || [model.certType isEqualToString:@"consumeInfo"]) {
        if ([model.certStatus isEqualToString:@"Success"]) {
            //已完善
            self.certStatusLabel.textColor = UICOLOR_FROM_HEX(0xA0AFC3);
        } else if ([model.certStatus isEqualToString:@"Fail"]) {
            //上传失败
            self.certStatusLabel.textColor = UICOLOR_FROM_HEX(0xF03C28);
        } else if ([model.certStatus isEqualToString:@"Submit"]) {
            //已提交,认证中
            self.certStatusLabel.textColor = UICOLOR_FROM_HEX(0xFFC000);
        } else if ([model.certStatus isEqualToString:@"Expired"]) {
            //过期,算未完善
            self.certStatusLabel.textColor = kThemeColorMain;
        }else {
            //NotDone,未完善
            self.certStatusLabel.textColor = kThemeColorMain;
        }
    } else {
        if ([model.certStatus isEqualToString:@"Success"]) {
            self.certStatusLabel.textColor = UICOLOR_FROM_HEX(0xA0AFC3);
        } else{
            self.certStatusLabel.textColor = kThemeColorMain;
        }
    }
}

#pragma mark - Getter
- (UILabel *)certNameLabel
{
    if (!_certNameLabel) {
        _certNameLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    }
    return _certNameLabel;
}

- (UILabel *)certContentLabel
{
    if (!_certContentLabel) {
        _certContentLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(12)];
    }
    return _certContentLabel;
    
}

- (UILabel *)certStatusLabel
{
    if (!_certStatusLabel) {
        _certStatusLabel = [UILabel labelWithText:@"" textColor:kThemeColorMain font:FONT_PINGFANG_X(12)];
    }
    return _certStatusLabel;
}

@end
