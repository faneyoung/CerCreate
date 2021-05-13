//
//  ZXSDVerifyUserinfoController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
#import "ZXSDCompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

// 用户信息查询&验证
@interface ZXSDVerifyUserinfoController : ZXSDBaseViewController

@property (nonatomic, strong) ZXSDCompanyModel *company;
//是否禁止返回
@property (nonatomic, assign) BOOL forbidBack;
//是否从登录流程进入
@property (nonatomic, assign) BOOL fromLogin;

@end

NS_ASSUME_NONNULL_END
