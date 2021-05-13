//
//  ZXSDExtendResultController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

typedef enum : NSUInteger {
    ZXSDExtendSuccess,
    ZXSDExtendFailure,
    ZXSDRepaymentSuccess,
    ZXSDRepaymentFailure
} ZXSDExtendResult;

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDExtendResultController : ZXSDBaseViewController

@property (nonatomic, assign) ZXSDExtendResult statusResult;
@property (nonatomic, copy) NSString *extendValidDate;

//展期失败原因
@property (nonatomic, copy) NSString *extendFailure;

//还款失败原因
@property (nonatomic, copy) NSString *repaymentFailure;

@end

NS_ASSUME_NONNULL_END
