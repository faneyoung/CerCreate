//
//  ZXPhoneUpdateInputCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PhoneUpdateType) {
    PhoneUpdateTypePhone,
    PhoneUpdateTypeName,
    PhoneUpdateTypeIdcard,
};

@interface ZXPhoneUpdateInputCell : ZXBaseCell

@property (nonatomic, assign) PhoneUpdateType type;

@property (nonatomic, strong) void(^inputBlock)(NSString *str,PhoneUpdateType type);

@end

NS_ASSUME_NONNULL_END
