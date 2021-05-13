//
//  ZXSDRepaymentDetailController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 立即还款
@interface ZXSDRepaymentDetailController : ZXSDBaseViewController

@property (nonatomic, strong) NSString *loanRefId;
@property (nonatomic, strong) NSString *bankcardRefId;

@end

NS_ASSUME_NONNULL_END
