//
//  ZXSDVerifyProgressCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVerifyProgressCell.h"

@interface ZXSDVerifyProgressCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ZXSDVerifyProgressCell

+ (CGFloat)height
{
    return 80;
}

- (void)initView
{
    
    [self.contentView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.contentView addSubview:self.stepLabel];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.typeLabel);
    }];
    
    
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(4);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDVerifyActionModel class]]) {
        return;
    }
    
    ZXSDVerifyActionModel *model = renderData;
    NSString *progress = [NSString stringWithFormat:@"%@ / %@", @(model.currentStep), @(model.totalActions)];
    
    self.stepLabel.text = progress;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.stepLabel.text];
    [attributedString setAttributes:
     @{
        NSFontAttributeName:FONT_SFUI_X_Medium(18),
        NSForegroundColorAttributeName:kThemeColorMain
     } range:NSMakeRange(0, 1)];
    self.stepLabel.attributedText = attributedString;
    
    self.typeLabel.text = model.name;
    self.progressView.progress = model.currentStep /(model.totalActions * 1.0);
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(20)];
    }
    return _typeLabel;
}

- (UILabel *)stepLabel
{
    if (!_stepLabel) {
        _stepLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_SFUI_X_Medium(14)];
    }
    return _stepLabel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.trackTintColor = UICOLOR_FROM_HEX(0xEAEFF2);
        _progressView.progressTintColor = kThemeColorMain;
        _progressView.progress = 0;
    }
    return _progressView;
}

@end
