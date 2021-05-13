//
//  ZXUserViewModel.h
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXSMSChannelModel.h"
#import "ZXSDBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SMSCodeTypeOpenMember, //开通会员
    SMSCodeTypeRefund,   //还款
    SMSCodeTypeExtend,//展期
} SMSCodeType;///发送验证码类型

@interface ZXUserViewModel : NSObject

///发送验证银行卡短信验证码(指定渠道)20201202
+ (void)sendSMSCodeWithCard:(ZXSDBankCardItem*)card phone:(NSString*)phone business:(NSString*)business completion:(void(^)(id data,NSError * _Nullable error))completion;
/// 发送验证码
/// @param dic 参数
/// @param type  验证码类型
+ (void)sendSMSCodeRequestWithPms:(NSDictionary*)dic type:(SMSCodeType)type completion:(void(^)(id data,NSError * _Nullable error))completion;

///绑定银行卡(指定渠道)20201202
+ (void)confirmChannelBankCardWithSMSCode:(NSString*)smsCode channel:(ZXSMSChannelModel*)channel completion:(void(^)(id data,NSError * _Nullable error))completion;

///创建会员 短信验证码
+ (void)createMemberSMSCodeRequestWithPms:(NSDictionary*)dic completion:(void(^)(id data,NSError * _Nullable error))completion;

///创建会员 确认支付
+ (void)createMembershipRequestWithPms:(NSDictionary*)dic completion:(void(^)(id data,NSError * _Nullable error))completion;


@end

NS_ASSUME_NONNULL_END
