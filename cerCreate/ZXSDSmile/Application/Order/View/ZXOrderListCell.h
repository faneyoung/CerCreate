//
//  ZXOrderListCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, OrderBtnType) {
    OrderBtnTypeDetail,
    OrderBtnTypeToPay,
};
@interface ZXOrderListCell : ZXBaseCell
///按钮类型
@property (nonatomic, strong) void(^orderBtnBlock)(OrderBtnType actionType);

@end

NS_ASSUME_NONNULL_END
