//
//  ZXCompanyCheckModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCompanyCheckModel : ZXBaseModel
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *oldPhone;
@property (nonatomic, strong) NSString *phone;

@end

NS_ASSUME_NONNULL_END
