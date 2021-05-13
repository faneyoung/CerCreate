//
//  EPNetworkManager+Home.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/8.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkManager.h"
#import "ZXSDHomeLoanInfo.h"
#import "ZXNewUserRegistCouponModel.h"
#import "ZXBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EPNetworkManager (Home)

+ (NSURLSessionDataTask *)getHomeLoanInfoWithParams:(nullable NSDictionary *)params completion:(void (^)(ZXSDHomeLoanInfo *model, NSError *error))completion;

+ (NSURLSessionDataTask *)doRiskCheckWithParams:(nullable NSDictionary *)params completion:(void (^)(NSString *eventRefId, NSError *error))completion;


/// 新注册用户优惠券弹窗
+ (void)requestNewUserCouponCompletion:(void (^)(id data, NSError *error))completion;

/// banners
/// @param completion completion
+ (void)requestBannerListCompletion:(void (^)(id data, NSError *error))completion;

/// banner点击统计
/// @param completion 回调
+ (void)analysisBanner:(NSString*)url Completion:(void (^)(id data, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
