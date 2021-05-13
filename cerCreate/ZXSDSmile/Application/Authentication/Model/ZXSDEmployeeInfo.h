//
//  ZXSDEmployeeInfo.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDEmployeeInfo : ZXSDBaseModel

__string(name) 
__string(idCard)
__string(bankName)
__string(bankCode)
__string(cardNumber)

__string(salary)
__string(payDay)

@end

NS_ASSUME_NONNULL_END
