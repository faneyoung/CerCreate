//
//  ZXSDVerifyBankCardController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 用户银行卡验证
@interface ZXSDVerifyBankCardController : ZXSDBaseViewController

@property (nonatomic, copy) void(^bindCardCompleted)(BOOL success,   NSError * _Nullable error);

// 是否需要绑卡操作，部分场景只需要展示信息
@property (nonatomic, assign) BOOL bindCard;
@property (nonatomic, assign) BOOL forbidBack;


@end

NS_ASSUME_NONNULL_END
