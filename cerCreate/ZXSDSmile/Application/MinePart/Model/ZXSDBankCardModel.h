//
//  ZXSDBankCardModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBankCardModel : ZXSDBaseModel

__string(phoneNumber) // 银行卡关联手机号
__string(bankLogoUrl)
__string(bankName)
__string(debitCardNumber) //银行卡号

@end


@interface ZXSDBankCardItem : ZXSDBaseModel

@property (nonatomic, assign) BOOL selected;

__string(number) //银行卡号
__string(reservePhone) // 银行卡关联手机号
__string(bankName)
__string(bankIcon)
__string(bankCode)

__string(refId)
///切换卡时，工资卡未上传工资明细，需要完成认证弹窗。false:需要弹窗；true：不需要弹窗
@property (nonatomic, assign) BOOL wageFlowIsValid;
///需要验证绑卡
@property (nonatomic, assign) BOOL isNeedValid;




///本地银行卡相关信息（背景色、右边logo）
- (NSDictionary *)UIConfig;

@end

NS_ASSUME_NONNULL_END
