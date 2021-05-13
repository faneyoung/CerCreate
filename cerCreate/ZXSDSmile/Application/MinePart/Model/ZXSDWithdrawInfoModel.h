//
//  ZXSDWithdrawInfoModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/28.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDWithdrawInfoModel : ZXSDBaseModel
///提现金额
@property (nonatomic, assign) double amount;
///服务费
@property (nonatomic, assign) double fee;

__string(currency)
__string(number)
__string(bankIcon)
__string(bankName)

@end

NS_ASSUME_NONNULL_END
