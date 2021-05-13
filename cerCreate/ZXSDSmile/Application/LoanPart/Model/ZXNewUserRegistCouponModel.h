//
//  ZXNewUserRegistCouponModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXNewUserRegistCouponModel : ZXBaseModel
@property (nonatomic, assign) BOOL needAlert;
@property (nonatomic, strong) NSString *faceValue;
@property (nonatomic, strong) NSString *url;


@end

NS_ASSUME_NONNULL_END
