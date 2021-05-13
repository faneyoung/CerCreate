//
//  ZXSDPhoneNumberVerifySMSCodeController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 手机号登录-验证码输入页面
@interface ZXSDPhoneNumberVerifySMSCodeController : ZXSDBaseViewController

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *phoneString;
@property (nonatomic, copy) NSString *smsCodeToken;

@end

NS_ASSUME_NONNULL_END
