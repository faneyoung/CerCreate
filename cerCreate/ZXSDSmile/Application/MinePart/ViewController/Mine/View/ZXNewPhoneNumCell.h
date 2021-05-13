//
//  ZXNewPhoneNumCell.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXNewPhoneNumCell : ZXBaseCell
@property (nonatomic, strong) void(^inputBlock)(NSString *str);

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *placeholderStr;
@property (nonatomic, assign) BOOL showCountry;


@end

NS_ASSUME_NONNULL_END
