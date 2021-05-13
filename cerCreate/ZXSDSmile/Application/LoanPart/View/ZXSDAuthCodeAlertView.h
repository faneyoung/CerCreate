//
//  ZXSDAuthCodeAlertView.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/6.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDAuthCodeAlertView : UIView

@property (nonatomic, copy) void(^sendCodeAction)(UIButton *sender, ZXSDAuthCodeAlertView *alert);
@property (nonatomic, copy) void(^updateAuthCode)(NSString *code);

- (void)clearAllWithBeginEdit:(BOOL)beginEdit;
- (void)updateCountdownValue;

@end

NS_ASSUME_NONNULL_END
