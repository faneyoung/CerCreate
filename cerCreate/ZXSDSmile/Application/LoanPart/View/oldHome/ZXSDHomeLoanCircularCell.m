//
//  ZXSDHomeLoanCircularCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/11/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeLoanCircularCell.h"
#import "MBCircularProgressBarView.h"
#import "ZXSDHomeLoanInfo.h"

@interface ZXSDHomeLoanCircularCell ()

@property (nonatomic, strong) MBCircularProgressBarView *progressBar;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) ZXSDHomeLoanInfo *info;

@end

@implementation ZXSDHomeLoanCircularCell

- (void)initView
{
    [self.contentView addSubview:self.progressBar];
    
    [self.progressBar addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressBar);
        make.centerY.equalTo(self.progressBar).offset(-12);
    }];
    
    UILabel *descLabel = [UILabel labelWithText:@"本月已工作 (天)" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(12)];
    [self.progressBar addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressBar);
        make.top.equalTo(self.dayLabel.mas_bottom).offset(2);
    }];
    
//    UIButton *tsetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    tsetBtn.backgroundColor = UIColor.brownColor;
//    [self.contentView addSubview:tsetBtn];
//    [tsetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.inset(20);
//        make.width.height.mas_equalTo(50);
//        make.centerY.offset(0);
//    }];
//    [tsetBtn bk_addEventHandler:^(id sender) {
//        [UIView animateWithDuration:0.01 animations:^{
//            self.progressBar.value = 0;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1 animations:^{
//                self.progressBar.value = self.info.loanModel.dayInterval;
//            }];
//        }];
//    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDHomeLoanInfo class]]) {
        return;
    }
    _info = renderData;
    
    ZXSDHomeLoanInfo *info = renderData;
    
    
    self.progressBar.maxValue = 34;
    self.progressBar.value = 0;
    self.dayLabel.text = @(info.loanModel.dayInterval).stringValue;
    
//    if (_animating) {
//        return;
//    }
//    self.animating = YES;

    self.progressBar.value = self.info.loanModel.dayInterval;
    
//    [UIView animateWithDuration:1 animations:^{
//        self.progressBar.value = self.info.loanModel.dayInterval;
//    } completion:^(BOOL finished) {
//        self.animating = NO;
//
//    }];
}

#pragma mark - Getter

- (MBCircularProgressBarView *)progressBar
{
    if (!_progressBar) {
        _progressBar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH() - 148)/2.0, 20, 148, 148)];
        _progressBar.progressLineWidth = 10;
        _progressBar.emptyLineWidth = 10;
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.progressCapType = 1;
        _progressBar.emptyCapType = 1;
        _progressBar.showValueString = NO;
        
        _progressBar.emptyLineColor = UICOLOR_FROM_HEX(0xEAEFF2);
        _progressBar.emptyLineStrokeColor = UICOLOR_FROM_HEX(0xEAEFF2);
        
        _progressBar.progressColor = kThemeColorMain;
        _progressBar.progressStrokeColor = kThemeColorMain;
    }
    return _progressBar;
        
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [UILabel labelWithText:@"0" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_SFUI_X_Semibold(32)];
    }
    return _dayLabel;
}

@end
