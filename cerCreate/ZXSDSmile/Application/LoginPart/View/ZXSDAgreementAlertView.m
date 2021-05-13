//
//  ZXSDAgreementAlertView.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/8.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAgreementAlertView.h"
#import "CJLabel.h"

@implementation ZXSDAgreementAlertView {
    UILabel *_titleLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUserInterfaceConfigure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame alertTitle:(NSString *)title alertTitleLines:(NSInteger)lines alertContent:(NSString *)content hasJumpLink:(BOOL)exist cancelButtonTitle:(NSString *)cancelTitle andConfirmButtonTitle:(NSString *)confirmTitle {
    self = [super initWithFrame:frame];
    if (self) {
        self.alertTitle = title;
        self.alertContent = content;
        self.cancelButtonTitle = cancelTitle;
        self.confirmButtonTitle = confirmTitle;
        self.alertTitleLines = lines;
        if (exist) {
            [self addUserInterfaceConfigureWithJumpLink];
        } else {
            [self addUserInterfaceConfigure];
        }
    }
    return self;
}

- (void)addUserInterfaceConfigure {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12.0;
    self.layer.masksToBounds = YES;
    
    CGFloat currentWidth = self.frame.size.width;
    CGFloat currentHeight = self.frame.size.height;
    CGFloat contentHeight = currentHeight - 40 - self.alertTitleLines * 28 - 64;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 20, currentWidth - 48, self.alertTitleLines * 28)];
    _titleLabel.text = self.alertTitle;
    _titleLabel.numberOfLines = self.alertTitleLines;
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    [self addSubview:_titleLabel];
    
    if (self.alertContent.length > 0) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame), currentWidth - 40, contentHeight)];
          contentLabel.text = self.alertContent;
          contentLabel.numberOfLines = 0;
          contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
          contentLabel.textAlignment = NSTextAlignmentLeft;
          contentLabel.textColor = UICOLOR_FROM_HEX(0x666666);
         [self addSubview:contentLabel];
    }
    
    if (self.cancelButtonTitle.length > 0 && self.confirmButtonTitle.length > 0) {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(20, self.frame.size.height - 64, 120, 44);
        [cancelButton setBackgroundColor:UICOLOR_FROM_HEX(0xF5F5F5)];
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.cornerRadius = 22.0;
        cancelButton.layer.masksToBounds = YES;
        [self addSubview:cancelButton];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(self.frame.size.width - 140, self.frame.size.height - 64, 120, 44);
        [confirmButton setBackgroundColor:kThemeColorMain];
        [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.layer.cornerRadius = 22.0;
        confirmButton.layer.masksToBounds = YES;
        [self addSubview:confirmButton];
    } else if (self.cancelButtonTitle.length > 0){
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(20, self.frame.size.height - 64, 260, 44);
        [cancelButton setBackgroundColor:UICOLOR_FROM_HEX(0xF5F5F5)];
        [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.cornerRadius = 22.0;
        cancelButton.layer.masksToBounds = YES;
        [self addSubview:cancelButton];
    } else {
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(20, self.frame.size.height - 64, 260, 44);
        [confirmButton setBackgroundColor:kThemeColorMain];
        [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
        [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        confirmButton.layer.cornerRadius = 22.0;
        confirmButton.layer.masksToBounds = YES;
        [self addSubview:confirmButton];
    }
}

- (void)addUserInterfaceConfigureWithJumpLink {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12.0;
    self.layer.masksToBounds = YES;
    
    CGFloat currentWidth = self.frame.size.width;
    CGFloat currentHeight = self.frame.size.height;
    CGFloat contentHeight = currentHeight - 40 - self.alertTitleLines * 28 - 64;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 20, currentWidth - 48, self.alertTitleLines * 28)];
    _titleLabel.text = self.alertTitle;
    _titleLabel.numberOfLines = self.alertTitleLines;
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    [self addSubview:_titleLabel];
    
    if (self.alertContent.length > 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.alertContent];
        CJLabel *contentLabel = [[CJLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleLabel.frame), currentWidth - 40, contentHeight)];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        
        WEAKOBJECT(self);
        attributedString = [CJLabel configureAttributedString:attributedString
                                                      atRange:NSMakeRange(0, attributedString.length)
                                                   attributes:@{
                                                                NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x666666),
                                                                NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0],
                                                                }];
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                             withString:@"《薪朋友用户服务协议》"
                                       sameStringEnable:NO
                                         linkAttributes:@{
                                                          NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                          NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0],
                                                          }
                                   activeLinkAttributes:nil
                                              parameter:nil
                                         clickLinkBlock:^(CJLabelLinkModel *linkModel){
                                             [weakself jumpToUserAgreementController];
                                         }longPressBlock:^(CJLabelLinkModel *linkModel){
                                             [weakself jumpToUserAgreementController];
                                         }];
        
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"《薪朋友平台用户隐私政策》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                                    NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                                    NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0],
                                                                    }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
                                                       [weakself jumpToPrivacyAgreementController];
                                                   }longPressBlock:^(CJLabelLinkModel *linkModel){
                                                       [weakself jumpToPrivacyAgreementController];
                                                   }];
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"《个人综合信息授权书》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                                    NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                                    NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0],
                                                                    }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            if (self.personalPrivacyBlock) {
                self.personalPrivacyBlock();
            }
                                                   }longPressBlock:^(CJLabelLinkModel *linkModel){
                                                       if (self.personalPrivacyBlock) {
                                                           self.personalPrivacyBlock();
                                                       }
                                                   }];

        contentLabel.attributedText = attributedString;
        contentLabel.extendsLinkTouchArea = YES;
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20, self.frame.size.height - 64, 120, 44);
    [cancelButton setBackgroundColor:UICOLOR_FROM_HEX(0xF5F5F5)];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 22.0;
    cancelButton.layer.masksToBounds = YES;
    [self addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(self.frame.size.width - 140, self.frame.size.height - 64, 120, 44);
    [confirmButton setBackgroundColor:kThemeColorMain];
    [confirmButton setTitle:self.confirmButtonTitle forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.layer.cornerRadius = 22.0;
    confirmButton.layer.masksToBounds = YES;
    [self addSubview:confirmButton];
}

- (void)cancelButtonClicked:(UIButton *)btn {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmButtonClicked:(UIButton *)btn {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

//跳转至用户协议
- (void)jumpToUserAgreementController {
    if (self.userAgreementBlock) {
        self.userAgreementBlock();
    }
}

//跳转至隐私协议
- (void)jumpToPrivacyAgreementController {
    if (self.privacyAgreementBlock) {
        self.privacyAgreementBlock();
    }
}

- (void)setTitleColor:(UIColor *)color {
    _titleLabel.textColor = color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
