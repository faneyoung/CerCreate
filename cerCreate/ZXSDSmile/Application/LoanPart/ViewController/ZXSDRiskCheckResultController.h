//
//  ZXSDRiskCheckResultController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

typedef enum : NSUInteger {
    ZXSDRiskResultTypeDoing, //审核中
    ZXSDRiskResultTypeReject, //拒绝
    ZXSDRiskResultTypeAccept, //通过
    ZXSDRiskResultTypeUndo // 未做风控审
} ZXSDRiskResultType;

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDRiskCheckResultController : ZXSDBaseViewController

@property (nonatomic, copy) NSString *eventRefId;

@end

NS_ASSUME_NONNULL_END
