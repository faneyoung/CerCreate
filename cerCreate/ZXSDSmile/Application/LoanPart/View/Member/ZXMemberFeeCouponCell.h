//
//  ZXMemberFeeCouponCell.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"
#import "ZXCouponListModel.h"
#import "ZXCouponCalculationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberFeeCouponCell : ZXBaseCell

- (void)updateWithData:(ZXCouponListModel*)selectCoupon cal:(ZXCouponCalculationModel*)calModel;

@end

NS_ASSUME_NONNULL_END
