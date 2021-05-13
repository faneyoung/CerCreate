//
//  ZXSDWithdrawItemModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDWithdrawItemModel : ZXSDBaseModel

__string(withdrawTime)

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat fee;

@end

NS_ASSUME_NONNULL_END
