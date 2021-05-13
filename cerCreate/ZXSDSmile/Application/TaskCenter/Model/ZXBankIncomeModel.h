//
//  ZXBankIncomeModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXBankIncomeModel : ZXBaseModel

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *desItems;

@property (nonatomic, strong) NSArray *uploadImgItems;

@end

NS_ASSUME_NONNULL_END
