//
//  ZXSMSChannelModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/7.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSMSChannelModel : ZXBaseModel
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) NSString *uniqueCode;

@end

NS_ASSUME_NONNULL_END
