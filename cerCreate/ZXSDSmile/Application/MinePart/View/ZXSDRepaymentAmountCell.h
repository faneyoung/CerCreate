//
//  ZXSDRepaymentAmountCell.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/1.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDExtendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDRepaymentAmountCell : ZXSDBaseTableViewCell

@property (nonatomic, copy) void(^showChargeAlert)(void);

@end

NS_ASSUME_NONNULL_END
