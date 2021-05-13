//
//  ZXSDExtendModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDExtendLoanInfo: ZXSDBaseModel

__string(fundDate)
__string(repayDate)
@property (nonatomic, assign) CGFloat principal;

@end

@interface ZXSDExtendModel : ZXSDBaseModel

__string(bankAccount) //银行卡号
__string(bankLogoUrl)
__string(bankName)
__string(bankcardRefId)

__string(channel) //
__string(loanRefId)

@property (nonatomic, assign) CGFloat extendFee; //展期费用
@property (nonatomic, assign) CGFloat interest; //利息
@property (nonatomic, assign) CGFloat total;

@property (nonatomic, strong) ZXSDExtendLoanInfo *oldLoan;
@property (nonatomic, strong) ZXSDExtendLoanInfo *extendLoan;

@end



@interface ZXSDRepaymentInfoModel : ZXSDBaseModel

__string(bankAccount) //银行卡号
__string(bankLogoUrl)
__string(bankName)
__string(currency)


@property (nonatomic, assign) CGFloat actualAmount;
@property (nonatomic, assign) CGFloat interest;
@property (nonatomic, assign) CGFloat principal;
@property (nonatomic, assign) CGFloat punishFee;

@end

NS_ASSUME_NONNULL_END
