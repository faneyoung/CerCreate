//
//  EPNetworkManager+Home.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/8.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager+Home.h"

// 首页用户状态信息&&信用额度
#define HOME_PERSONLOAN_URL @"/rest/userIndex/init"
// 发起风控
#define HOME_DORISK_URL @"/rest/loan/callRiskEvent"
///新注册用户优惠券弹窗
static NSString * const kHomeNewRegisterCoupon = @"rest/alert/index";

@implementation EPNetworkManager (Home)

+ (NSURLSessionDataTask *)getHomeLoanInfoWithParams:(NSDictionary *)params completion:(void (^)(ZXSDHomeLoanInfo *model, NSError *error))completion
{
    return [[EPNetworkManager defaultManager] getAPI:HOME_PERSONLOAN_URL parameters:nil decodeClass:[ZXSDHomeLoanInfo class] completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            ZXSDHomeLoanInfo *loanInfo = [ZXSDHomeLoanInfo modelWithJSON:response.originalContent];
            completion(loanInfo, nil);
        }
        
    }];
}

+ (NSURLSessionDataTask *)doRiskCheckWithParams:(nullable NSDictionary *)params completion:(void (^)(NSString *eventRefId, NSError *error))completion
{
    return [[EPNetworkManager defaultManager] postAPI:HOME_DORISK_URL parameters:nil decodeClass:NULL completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
        } else {
            NSString *eventRefId = [response.originalContent objectForKey:@"eventRefId"];
            completion(eventRefId, nil);
        }
        
    }];
}

+ (void)requestNewUserCouponCompletion:(void (^)(id data, NSError *error))completion{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"newRegisterCoupon" forKey:@"alertType"];
    [[EPNetworkManager defaultManager] getAPI:kHomeNewRegisterCoupon parameters:tmps.copy decodeClass:NULL completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        ZXNewUserRegistCouponModel *model = [ZXNewUserRegistCouponModel instanceWithDictionary:response.originalContent];
        completion(model, nil);

        
    }];
}

+ (void)requestBannerListCompletion:(void (^)(id data, NSError *error))completion{
    
    [[EPNetworkManager defaultManager] getAPI:kPath_homeBannerList parameters:nil decodeClass:NULL completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (response.resultModel.code != 0) {
            EPNetworkError *err = [EPNetworkError errorWithMessage:response.resultModel.responseMsg originalError:nil];
            completion(nil, err);
            return;
        }
        
        NSArray *banners = [ZXHomeBannerModel modelsWithData:response.resultModel.data];
        
        completion(banners, nil);

    }];

}



+ (void)analysisBanner:(NSString*)url Completion:(void (^)(id data, NSError *error))completion{
    
    if (!IsValidString(url)) {
        return;
    }
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:url forKey:@"url"];
    
    [[EPNetworkManager defaultManager] postAPI:kPath_bannerAnalysis parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (response.resultModel.code != 0) {
            EPNetworkError *err = [EPNetworkError errorWithMessage:response.resultModel.responseMsg originalError:nil];
            completion(nil, err);
            return;
        }
        
        
        completion(@"success", nil);

    }];

}



@end
