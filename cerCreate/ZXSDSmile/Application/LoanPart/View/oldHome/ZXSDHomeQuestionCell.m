//
//  ZXSDHomeQuestionCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeQuestionCell.h"
#import "TYCyclePagerView.h"

@interface ZXSDHomeQuestionCell ()

@property (nonatomic, strong) TYCyclePagerView *pagerView;

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation ZXSDHomeQuestionCell

- (void)initView
{
    self.backgroundColor = UICOLOR_FROM_HEX(0xFFFFFF);
    
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.readLabel];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(19);
        make.width.height.mas_equalTo(28);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).offset(12);
        make.centerY.equalTo(self.avatar);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar);
        make.top.equalTo(self.avatar.mas_bottom).offset(16);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
    }];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.descLabel);
        make.top.equalTo(self.descLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDHomeQuestionModel class]]) {
        return;
    }
    
    ZXSDHomeQuestionModel *model = (ZXSDHomeQuestionModel *)renderData;
    
    self.avatar.image = [UIImage imageNamed:model.avatar];
    self.phoneLabel.text = model.phone;
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    
    NSString *value = [NSString stringWithFormat:@"%@次阅读", model.readNumber];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:value];
    [attr addAttributes:@{NSFontAttributeName:FONT_SFUI_X_Regular(12)} range:NSMakeRange(0, model.readNumber.length)];
    self.readLabel.attributedText = attr;
    
    
    NSString *desc = [NSString stringWithFormat:@"%@%@", model.desc, @"阅读全部"];
    NSMutableAttributedString *descAttr = [[NSMutableAttributedString alloc] initWithString:desc];
    [descAttr addAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(123,155,225)} range:NSMakeRange(desc.length - 4, 4)];
    self.descLabel.attributedText = descAttr;
}

#pragma mark - TYCyclePagerViewDataSource

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    ZXSDHomeQuestionModel *model = [self.questions objectAtIndex:index];
    if (self.showDetail) {
        self.showDetail(model.detailURL);
    }
}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X_Medium(16)];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(14)];
        _descLabel.numberOfLines = 3;
    }
    return _descLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_SFUI_X_Regular(14)];
        
    }
    return _phoneLabel;
}

- (UILabel *)readLabel
{
    if (!_readLabel) {
        _readLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(12)];
    }
    return _readLabel;
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [UIImageView new];
        //_avatar.layer.cornerRadius = 14;
    }
    return _avatar;
}


@end

