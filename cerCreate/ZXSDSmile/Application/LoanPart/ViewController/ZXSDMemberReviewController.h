//
//  ZXSDMemberReviewController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"
@class ZXSDBankCardItem;

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDMemberReviewController : ZXSDBaseViewController
///会员开通状态，有没有会员。YES && loanAmount<500时直接预支
@property (nonatomic, assign) BOOL haveCustomer;
///当前预支的额度是否需要开通会员
@property (nonatomic, assign) BOOL flag;

/// 会员起始有效期
@property (nonatomic, copy) NSString *customerValidDate;
/// 会员截止有效期
@property (nonatomic, copy) NSString *customerInvalidDate;
///额度
@property (nonatomic, copy) NSString *loanAmount;
///利息
@property (nonatomic, copy) NSString *interest;
///扣款日
@property (nonatomic, copy) NSString *repaymentDate;

// 预支相关
@property (nonatomic, strong) NSNumber *installPeriodLength;
@property (nonatomic, strong) NSNumber *installPeriodNum;
@property (nonatomic, copy) NSString *installPeriodUnit;
@property (nonatomic, copy) NSString *loanType;
///选择的银行卡
@property (nonatomic, strong) ZXSDBankCardItem *bankCardItem;

@end

NS_ASSUME_NONNULL_END
