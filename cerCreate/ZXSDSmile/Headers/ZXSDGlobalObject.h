//
//  ZXSDGlobalObject.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXSDCompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Notification
// 用户登录成功
#define ZXSD_notification_userLogin @"zxsd_notification_userlogin"

// 用户登出
#define ZXSD_NOTIFICATION_USERLOGOUT @"zxsd_notification_userlogout"

// 有新消息
#define ZXSD_notification_newMessage @"kRefreshMessageCount"

// 引导页查看完毕
#define ZXSD_NOTIFICATION_APPGUIDE_FINISH @"zxsd_notification_appguide_finish"

// 刷新首页
static NSString * const ZXSD_NOTIFICATION_REFRESH_HOME = @"zxsd_notification_refresh_home";
///刷新任务中心
static NSString * const kNotificationRefreshTaskCenter = @"kNotificationRefreshTaskCenter";

// 消息
static NSString * const kNotificationRefreshMessage = @"kNotificationRefreshMessage";

// 额度资格评估
static NSString * const kNotificationRefreshAmountEvaluate = @"kNotificationRefreshAmountEvaluate";
///刷新订单数量
static NSString * const kNotificationRefreshOrderCount = @"kNotificationRefreshOrderCount";


#pragma mark - User Protocol

// 用户隐私政策
#define PRIVACY_AGREEMENT_URL @"/agreement/privacy.html"

// 用户服务协议
#define USER_SERVICE_URL @"/agreement/service_agreement.html"

// 预支薪资协议
#define EXTEND_AGREEMENT_URL @"/agreement/loan_contract.html"

// 委托扣款协议
#define ADVANCE_SALARY_AGREEMENT_URL @"/agreement/payment_agreement.html"

//个人信息授权协议
#define PERSONAL_INFO_AGREEMENT_URL @"/agreement/consent.html"

//薪朋友会员服务协议
#define ZXSD_CUSTOMER_URL @"agreement/customer_agreement.html"

typedef enum : NSUInteger {
    MemberReviewStatus1, // 未开通,非smile+
    MemberReviewStatus2, // 未开通,smile+
    MemberReviewStatus3 // 已开通,smile+
} MemberReviewStatus;


@interface ZXSDGlobalObject : NSObject

+ (instancetype)sharedGlobal;

@property (nonatomic, strong) NSArray<ZXSDCompanyModel*> *innerCompanys;

// 当前账户登陆所用的运营商
@property (nonatomic, copy) NSString *operatorName;

// 网络环境
@property (nonatomic, copy) NSString *networkState;

- (void)startNetworkMonitoring;

@end

NS_ASSUME_NONNULL_END
