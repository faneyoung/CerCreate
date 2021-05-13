//
//  ZXCouponSMSModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCouponSMSModel : ZXBaseModel

@property (nonatomic, strong) NSString *bankcardRefId;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, assign) BOOL isSkipCheckSms;
@property (nonatomic, strong) NSString *channelCode;

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) NSString *smsSendNo;

@end

NS_ASSUME_NONNULL_END
/**
 "payStatus":"", //支付状态
 "payMessage":"", //支付信息
 "refId":"", //订单编号
 "amount":"", //金额
 "smsSendNo":"", //短信发送码
 "payCode":"", //支付码

 */
