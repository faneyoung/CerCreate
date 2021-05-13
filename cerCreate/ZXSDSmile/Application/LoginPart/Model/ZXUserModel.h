//
//  ZXUserModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/1/27.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"
/**
 20210127update：之前用户相关的信息都是关联到ZXSDCurrentUser里的。
 此类以后用来保存用户信息
 */
/**
 "bankCardCount": 0, // 银行卡数量
 "commonCouponCount": 0,  // 优惠券数量
 "validDateTime": "",  // 开始时间
 "invalidDateTime": "",  // 结束时间
 "isH5Recommend":false,// false:否 true:是
 "actionStatus":"CALL_RISK", //首页Action
 "nickName": "**明",//或  "131****0434" 昵称
 "balance": 200.00, //可体现金额
 "isVerify":true, //是否完成认证
 "isCustomer":true, //是否会员期内
 "isSmilePlus":false, //是否TO B会员
 "payDay": 12, //发薪日
 "quota":500 //额度

 */
NS_ASSUME_NONNULL_BEGIN

@interface ZXUserModel : ZXBaseModel
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSString *payDay;

///是否完成认证
@property (nonatomic, assign) BOOL isVerify;
///首页Action
@property (nonatomic, strong) NSString *actionStatus;
///是否会员期内
@property (nonatomic, assign) BOOL isCustomer;
///是否TO B会员
@property (nonatomic, assign) BOOL isSmilePlus;

///额度
@property (nonatomic, strong) NSString *quota;
///可体现金额
@property (nonatomic, strong) NSString *balance;
///优惠券数量
@property (nonatomic, strong) NSString *commonCouponCount;
/// 银行卡数量
@property (nonatomic, strong) NSString *bankCardCount;
///开始时间
@property (nonatomic, strong) NSString *validDateTime;
/// 结束时间
@property (nonatomic, strong) NSString *invalidDateTime;

///邀请 是否是h5邀请页面
@property (nonatomic, assign) BOOL isH5Recommend;



@end

NS_ASSUME_NONNULL_END
