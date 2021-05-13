//
//  ZXSDPhoneNumberLoginController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 手机号登录
@interface ZXSDPhoneNumberLoginController : ZXSDBaseViewController

//从一键登录页面进入的可以返回，默认返回功能关闭
@property (nonatomic, assign) BOOL isCanBack;

@end

NS_ASSUME_NONNULL_END
