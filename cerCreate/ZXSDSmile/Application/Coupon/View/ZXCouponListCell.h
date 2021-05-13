//
//  ZXCouponListCell.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CouponListCellType) {
    CouponListCellTypeDefault,
    CouponListCellTypeSelect,
};

@interface ZXCouponListCell : ZXBaseCell
@property (nonatomic, strong) void (^couponListCellNoteBlock)(int type);
@property (nonatomic, strong) void (^couponListCellUseBlock)(id data);

@property (nonatomic, assign) CouponListCellType cellType;

@end

NS_ASSUME_NONNULL_END
