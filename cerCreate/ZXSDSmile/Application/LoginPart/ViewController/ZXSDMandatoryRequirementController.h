//
//  ZXSDMandatoryRequirementController.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/8.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnVoidBlock)(void);

// 用户协议展示&控制（强制同意）
@interface ZXSDMandatoryRequirementController : ZXSDBaseViewController

@property (nonatomic, copy) ReturnVoidBlock jumpAgreementBlock;

@end

NS_ASSUME_NONNULL_END
