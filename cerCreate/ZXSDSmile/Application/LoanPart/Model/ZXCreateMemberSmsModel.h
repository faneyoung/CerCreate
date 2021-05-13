//
//  ZXCreateMemberSmsModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/2/25.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXCreateMemberSmsModel : ZXBaseModel

@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *smsSendNo;

@property (nonatomic, strong) NSString *payStatus;
@property (nonatomic, strong) NSString *payMessage;

///是否可以重新发送验证码.只依赖倒计时，倒计时结束后为YES
@property (nonatomic, assign) BOOL canSendCode;


@end

NS_ASSUME_NONNULL_END

/**
 "payStatus": "Waiting",
 "payMessage": "短信已下发，需验证短信验证码",
 "refId": "kxtJex_2Ia390_SMIL",
 "amount": 30,
 "smsSendNo": "1fcb4bdc687d0b19ac9634ec538611ef"

 */
