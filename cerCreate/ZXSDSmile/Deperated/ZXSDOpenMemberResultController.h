//
//  ZXSDOpenMemberResultController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDOpenMemberResultController : ZXSDBaseViewController

@property (nonatomic, assign) BOOL  success;
@property (nonatomic, copy) NSString *errorStr;

// 会员起始有效期
@property (nonatomic, copy) NSString *customerValidDate;
// 会员截止有效期
@property (nonatomic, copy) NSString *customerInvalidDate;


// 预支相关
@property (nonatomic, strong) NSNumber *installPeriodLength;
@property (nonatomic, strong) NSNumber *installPeriodNum;
@property (nonatomic, copy) NSString *installPeriodUnit;
@property (nonatomic, copy) NSString *loanType;
@property (nonatomic, copy) NSString *loanAmount;

@end

NS_ASSUME_NONNULL_END
