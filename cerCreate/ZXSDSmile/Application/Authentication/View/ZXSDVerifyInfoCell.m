//
//  ZXSDVerifyInfoCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVerifyInfoCell.h"

@interface ZXSDVerifyInfoCell ()


@end

@implementation ZXSDVerifyInfoCell

- (void)initView
{
    [self.contentView addSubview:self.keyLabel];
    [self.contentView addSubview:self.valueLabel];
    
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDEmployeeInfo class]]) {
        return;
    }
    
    ZXSDEmployeeInfo *model = renderData;
    self.valueLabel.text = model.name;
}

- (UILabel *)keyLabel
{
    if (!_keyLabel) {
        _keyLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    }
    return _keyLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x626F8A) font:FONT_PINGFANG_X(14)];
    }
    return _valueLabel;
}

@end
