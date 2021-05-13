//
//  ZXMemberUserInfo.h
//  ZXSDSmile
//
//  Created by Fane on 2021/2/25.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXMemberUserInfo : ZXBaseModel
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *payStatus;


@end

NS_ASSUME_NONNULL_END
