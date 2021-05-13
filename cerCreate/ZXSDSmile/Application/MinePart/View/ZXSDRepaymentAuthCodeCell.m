//
//  ZXSDRepaymentAuthCodeCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/6.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDRepaymentAuthCodeCell.h"
#import "CRBoxInputView.h"

static const NSInteger SMSCODE_TIME_MAX_LENGTH = 59;
static const NSInteger SMSCODE_LENGTH = 6;

@interface ZXSDRepaymentAuthCodeCell()

@property (nonatomic, strong) CRBoxInputView *boxInputView;
@property (nonatomic, strong) UIButton *sendCodeButton;

@end

@implementation ZXSDRepaymentAuthCodeCell

- (void)initView
{
    UILabel *label = [UILabel labelWithText:@"身份验证" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(30);
    }];
    
    [self.contentView addSubview:self.sendCodeButton];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(17);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview:self.boxInputView];
    [self.boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(13);
        make.right.equalTo(self.sendCodeButton.mas_left).offset(-10);
        make.left.equalTo(label);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.contentView).offset(-10);
        
    }];
    
}

- (void)verifySmsCodeAndLogin:(NSString *)smsCodeString
{
    if (self.updateAuthCode) {
        self.updateAuthCode(smsCodeString);
    }
}

//重新发送验证码
- (void)sendCodeButtonClicked:(UIButton *)btn
{
    if (self.sendCodeAction) {
        self.sendCodeAction(btn, self);
    }
}

- (void)updateCountdownValue {
    __block NSInteger timeout = SMSCODE_TIME_MAX_LENGTH;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButton.userInteractionEnabled = YES;
                [self.sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.sendCodeButton setTitleColor:UICOLOR_FROM_HEX(0x00B050) forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout % (timeout + 1);
            NSString *stringTime = [NSString stringWithFormat:@"%ld",(long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButton.userInteractionEnabled = NO;
                [self.sendCodeButton setTitleColor:UICOLOR_FROM_HEX(0x999999) forState:UIControlStateNormal];
                [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%@ s", stringTime] forState:UIControlStateNormal];
            });
            timeout --;
        }
    });
    dispatch_resume(timer);
}

- (CRBoxInputView *)boxInputView
{
    if (!_boxInputView) {
        
        CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
        cellProperty.showLine = YES;
        cellProperty.cellCursorWidth = 3.0;
        cellProperty.cellCursorHeight = 24.0;
        cellProperty.cellCursorColor = kThemeColorMain;
        cellProperty.cornerRadius = 0;
        cellProperty.borderWidth = 0;
        cellProperty.cellFont = FONT_SFUI_X_Regular(20);
        cellProperty.cellTextColor = UICOLOR_FROM_HEX(0x333333);
        cellProperty.customLineViewBlock = ^CRLineView * _Nonnull{
            CRLineView *lineView = [CRLineView new];
            lineView.underlineColorNormal = [UICOLOR_FROM_HEX(0x333333) colorWithAlphaComponent:0.3];
            lineView.underlineColorSelected = [UICOLOR_FROM_HEX(0x333333) colorWithAlphaComponent:0.7];
            lineView.underlineColorFilled = UICOLOR_FROM_HEX(0x333333);
            [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
                make.left.right.bottom.offset(0);
            }];
            return lineView;
        };
        
        _boxInputView = [CRBoxInputView new];
        _boxInputView.codeLength = SMSCODE_LENGTH;
        _boxInputView.customCellProperty = cellProperty;
        [_boxInputView loadAndPrepareViewWithBeginEdit:NO];
        
        @weakify(self);
        _boxInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
            @strongify(self);
            if (isFinished && text.length > 0) {
                [self verifySmsCodeAndLogin:text];
            }
        };
    }
    return _boxInputView;
}

- (UIButton *)sendCodeButton
{
    if (!_sendCodeButton) {
        _sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCodeButton.backgroundColor = [UIColor clearColor];
        [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:UICOLOR_FROM_HEX(0x00B050) forState:UIControlStateNormal];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        _sendCodeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _sendCodeButton.userInteractionEnabled = YES;
        _sendCodeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -5, -15, -20);
    }
    return _sendCodeButton;
}

@end
