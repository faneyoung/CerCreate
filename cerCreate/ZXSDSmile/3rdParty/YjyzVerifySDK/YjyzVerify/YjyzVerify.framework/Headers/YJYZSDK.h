//
//  YJYZSDK.h
//  YjyzVerify
//
//  Created by yjyz on 2019/11/29.
//  Copyright © 2019 yjyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJYZSDKDefine.h"
#import "YJYZUIModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJYZSDK : NSObject

/**
 设置预登陆超时时间

 @param timeout 超时时间(默认5s)
 */
+ (void)yjyzSetTimeoutInterval:(NSTimeInterval)timeout;

/**
 注册appKey、appSecret
 
 @param appKey appKey
 @param appSecret appSecret
 @param operationType (默认填入0) 配置支持的运营商类型 默认支持联通 + 移动 + 电信
 
 0: 移动 + 联通 + 电信
 1: 移动
 2: 联通
 3: 移动 + 联通
 4: 电信
 5: 移动 + 电信
 6: 联通 + 电信
 
 */
+ (void)yjyzRegisterAppKey:(NSString * _Nonnull)appKey
                 appSecret:(NSString * _Nonnull)appSecret operationType:(NSInteger)operationType;

/**
 预取号
 获取临时凭证
 @param handler 返回字典和error , 字典中包含运营商类型. error为nil即为成功.
 */
+ (void)yjyzPreGetPhoneNumber:(nullable YjyzVerifyResultHander)handler;


/**
 一键登录
 需在预登陆完成后调用

 @param model 需要配置的model属性（authViewController属性毕传）
 @param completion 回调. error为nil即为成功. 成功则得到token、operatorToken、operatorType，之后向服务器请求获取完整手机号
 */
+ (void)yjyzAuthLoginWithModel:(nonnull YJYZUIModel *)model completion:(nullable YjyzVerifyResultHander)completion;

/**
 关闭授权页
 注：若授权页未拉起，此方法调用无效果，complete不触发。内部实现为调用系统方法dismissViewcontroller:Complete。
 @param completion dismissViewcontroller`completion
 */
+ (void)yjyzManualCloseLoginVc: (void (^ __nullable)(void))completion;

/**
 appkey
 */
+ (NSString *)appkey;

/// 获取 SDK Version
+ (NSString *)yjyzVersion;

@end

NS_ASSUME_NONNULL_END
