//
//  ZXAccountSecurityModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/27.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAccountSecurityModel : ZXBaseModel

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL status;

@property (nonatomic, strong) NSArray *societyAccounts;


@end

NS_ASSUME_NONNULL_END
