//
//  ZXUserViewModel.m
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXUserViewModel.h"
#import "EPNetworkManager.h"

//static  NSString * const kPathCreateMemebership = @"rest/loan/teller/repayMembershipFee";

static  NSString * const kSMSCodeBank = @"rest/bankCard/validate/prepareByChannelName";
static NSString *const kConfirmByChannel = @"rest/bankCard/validate/confirmByChannelName";

@implementation ZXUserViewModel

///发送验证银行卡短信验证码(指定渠道)20201202
+ (void)sendSMSCodeWithCard:(ZXSDBankCardItem*)card phone:(NSString*)phone business:(NSString*)business completion:(void(^)(id data,NSError * _Nullable error))completion{
    if (!IsValidString(card.number)) {
        return;
    }
    
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:card.number forKey:@"bankCardNo"];
    [pms setSafeValue:card.bankCode forKey:@"bankCode"];
    [pms setSafeValue:card.bankName forKey:@"bankName"];
    [pms setSafeValue:card.refId forKey:@"bankcardRefId"];
    [pms setSafeValue:phone forKey:@"phone"];
    [pms setSafeValue:business forKey:@"businessScenario"];

    [[EPNetworkManager defaultManager] postAPI:kSMSCodeBank parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_safe_async_main(^{
                completion(nil, error);
                
            });
            return;
        }
        
        ZXSMSChannelModel *model = [ZXSMSChannelModel instanceWithDictionary:response.originalContent];
        
        dispatch_safe_async_main(^{
            completion(model,nil);
        });
    }];

}

+ (void)createMemberSMSCodeRequestWithPms:(NSDictionary*)dic completion:(void(^)(id data,NSError * _Nullable error))completion{
    
    /**
     "amount": 30, //会员费
     "level":"VIP1", // 会员费级别 20210203
     "bankcardRefId":"s3Od9", // 银行卡ID
     "couponRefId":"0Qm42" //优惠券ID

     */
    
    [[EPNetworkManager defaultManager] postAPI:kPath_createMemberSmsCode parameters:dic decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_safe_async_main(^{
                completion(nil, error);
                
            });
            return;
        }
        
        dispatch_safe_async_main(^{
            completion(response,nil);
        });
    }];
}


+ (void)sendSMSCodeRequestWithPms:(NSDictionary*)dic type:(SMSCodeType)type completion:(void(^)(id data,NSError * _Nullable error))completion{
    
    NSMutableDictionary *pms = dic.mutableCopy;
    if (type == SMSCodeTypeOpenMember) {
        [pms setSafeValue:@"OPT_CUSTOMER_FEE" forKey:@"type"];
    }
    else if (type == SMSCodeTypeRefund){
        [pms setSafeValue:@"OTP_REPAY" forKey:@"type"];

    }
    else if(type == SMSCodeTypeExtend){
        [pms setSafeValue:@"OTP_EXTENDED" forKey:@"type"];
    }
    
    
    [[EPNetworkManager defaultManager] postAPI:kPathSendVerifyCode parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_safe_async_main(^{
                completion(nil, error);
                
            });
            return;
        }
        
        dispatch_safe_async_main(^{
            completion(response,nil);
        });
        
        //            ZXSDHomeLoanInfo *loanInfo = [ZXSDHomeLoanInfo modelWithJSON:response.originalContent];
        //            completion(loanInfo, nil);
        
        
        
        
    }];
}

//绑定银行卡(指定渠道)20201202
+ (void)confirmChannelBankCardWithSMSCode:(NSString*)smsCode channel:(ZXSMSChannelModel*)channel completion:(void(^)(id data,NSError * _Nullable error))completion{
    
    if (!IsValidString(smsCode) ||
        !channel) {
        return;
    }
    
    NSMutableDictionary *pms = @{}.mutableCopy;
    [pms setSafeValue:smsCode forKey:@"smsCode"];
    [pms setSafeValue:channel.channel forKey:@"channel"];
    [pms setSafeValue:channel.refId forKey:@"refId"];
    [pms setSafeValue:channel.uniqueCode forKey:@"uniqueCode"];
    [[EPNetworkManager defaultManager] putAPI:kConfirmByChannel parameters:pms.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_safe_async_main(^{
                completion(nil, error);
            });
            return;
        }
        
        
        dispatch_safe_async_main(^{
            completion(response,nil);
        });
        
    }];

}

+ (void)createMembershipRequestWithPms:(NSDictionary*)dic completion:(void(^)(id data,NSError * _Nullable error))completion{

    [[EPNetworkManager defaultManager] postAPI:kPath_memberPayConfirm parameters:dic decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"----------%@",response.modelToJSONString);
        
        if (error) {
            dispatch_safe_async_main(^{
                completion(nil, error);
                
            });
            return;
        }
        
        dispatch_safe_async_main(^{
            completion(response,nil);
        });
    }];
    
}



@end
