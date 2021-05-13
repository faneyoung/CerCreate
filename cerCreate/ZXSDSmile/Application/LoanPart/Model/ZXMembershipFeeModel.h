//
//  ZXMembershipFeeModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMembershipFeeModel : ZXBaseModel

///会员费，客户端写死 == 30
@property (nonatomic, strong) NSString *memberFee;

///有效期 起
@property (nonatomic, strong) NSString *customerValidDate;
///有效期 止
@property (nonatomic, strong) NSString *customerInvalidDate;
///贷款周期长度
@property (nonatomic, strong) NSString *installPeriodLength;
///贷款周期单位"D"
@property (nonatomic, strong) NSString *installPeriodUnit;
///贷款期数
@property (nonatomic, strong) NSString *installPeriodNum;
///贷款产品Code. 例 "smile1"
@property (nonatomic, strong) NSString *loanType;
///贷款金额
@property (nonatomic, strong) NSString *loanAmount;

@end

NS_ASSUME_NONNULL_END
