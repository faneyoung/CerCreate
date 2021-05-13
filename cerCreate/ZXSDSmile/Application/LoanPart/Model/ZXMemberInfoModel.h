//
//  ZXMemberInfoModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/2/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXSDHomeLoanInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberInfoModel : ZXBaseModel

/**
 haveCustomer    会员开通状态,是否是会员
 isNeedCustomer 是否需要开通会员
 
 customerOpen    当前预支的额度是否需要开通会员
 
 */
///会员开通状态
@property (nonatomic, assign) BOOL haveCustomer;
///是否需要开通会员
@property (nonatomic, assign) BOOL isNeedCustomer;

@property (nonatomic, strong) NSString *loanDetails;//rateDesc
@property (nonatomic, strong) NSString *repaymentType;//repayType
///扣款日
@property (nonatomic, strong) NSString *repaymentDate;//payDate
@property (nonatomic, strong) NSString *loanType;//loanCode

/// VA模式是否需要验证
@property (nonatomic, assign) BOOL isNeedVerify;
///isNeedVerify==YES时跳转路径
@property (nonatomic, strong) NSString *action;


@property (nonatomic, assign) BOOL isSuccess;
/// 会员起始有效期
@property (nonatomic, copy) NSString *customerValidDate;
/// 会员截止有效期
@property (nonatomic, copy) NSString *customerInvalidDate;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cooperationModel;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSArray <ZXSDHomeCreditItem *> *configInfos;//creditLimitList
@property (nonatomic, strong) NSArray *loanAmountArray;

@property (nonatomic, strong) NSString *advanceCouponRefId;


//当前预支的额度是否需要开通会员
//@property (nonatomic, assign) BOOL customerOpen;
/////额度
//@property (nonatomic, copy) NSString *loanAmount;
/////利息
//@property (nonatomic, copy) NSString *interest;

// 预支相关
@property (nonatomic, strong) NSNumber *installPeriodLength;
@property (nonatomic, strong) NSNumber *installPeriodNum;
@property (nonatomic, copy) NSString *installPeriodUnit;




@end

NS_ASSUME_NONNULL_END
