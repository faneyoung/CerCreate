//
//  ZXSDCerFlowInfoModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDCerFlowInfoModel : ZXSDBaseModel

__string(flowCode)
__string(flowName)
__string(flowFullName)
__string(recipient) // 邮箱

__string(status)
__string(statusName)

__string(title)
__string(userId)
__string(verifyCode)

@property (nonatomic, assign) BOOL encrypted;
@property (nonatomic, assign) BOOL forceEncrypted;
@property (nonatomic, assign) BOOL needIdCard;

@end

NS_ASSUME_NONNULL_END
