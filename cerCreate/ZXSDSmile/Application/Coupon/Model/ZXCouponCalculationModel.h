//
//  ZXCouponCalculationModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCouponCalculationModel : ZXBaseModel
///总金额
@property (nonatomic, strong) NSString *totalAmount;
///减免金额
@property (nonatomic, strong) NSString *deductionAmount;
///实付
@property (nonatomic, strong) NSString *payAmount;


@end

NS_ASSUME_NONNULL_END
