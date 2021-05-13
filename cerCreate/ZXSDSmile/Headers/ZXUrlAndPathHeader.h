//
//  ZXUrlAndPathHeader.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef ZXUrlAndPathHeader_h
#define ZXUrlAndPathHeader_h

#pragma mark - 用户 -
///微信登录
static NSString * const kPath_weixinAppLogin = @"rest/anon/weixinAppLogin";

///获取短信验证码
static NSString * const kPath_sendSMSCode = @"/rest/anon/sms";
///短信&验证码 登录
static NSString * const kPath_smsValidLogin = @"rest/anon/login";

///获取短信验证码-->匿名换绑
static NSString * const kPath_changePhoneSendSMSCode = @"/rest/anon/sendValidSms";
///校验验证码-->匿名换绑
static NSString * const kPath_changePhoneValidSMSCode = @"/rest/anon/validSms";

#pragma mark - 公司选择 -

static NSString * const kPath_queryInnerCompany = @"/rest/company/status?status=3";

///雇主检查
static NSString * const kPath_companyCheck = @"/rest/company/check";
///宜信授权 手机号切换
static NSString * const kPath_companyPhoneChangeSubmit = @"rest/company/phoneChangeSubmitForApp";

#pragma mark - 首页 -
///banner
static NSString * const kPath_homeBannerList = @"rest/banner/list/new";

#pragma mark - 个人中心 -

///邀请好友
static NSString * const kPath_inviteFriends = @"app/activity/share";
///合伙人计划
static NSString * const kPath_partner = @"app/activity/partner";
///钱包
static NSString * const kPath_reward = @"app/activity/reward";

///用户信息
static NSString * const kPath_userInfo = @"rest/userInfo/queryUserInfo";

///四要素状态查询
static NSString * const kPath_verifyStatus = @"/rest/userIndex/certStatus";

///换绑-->页面初始化 (判断用户是否绑卡成功)
static NSString * const kPath_phoneUpdateInit = @"rest/userPhoneUpdate/init";
///换绑-->发送校验短信
static NSString * const kPath_phoneUpdateSendSmsCode = @"rest/userPhoneUpdate/sendValidSms";
///换绑-->校验验证码
static NSString * const kPath_phoneUpdateCodeValidSms = @"rest/userPhoneUpdate/validSms";
///换绑-->校验身份信息
static NSString * const kPath_phoneUpdateValidPersonInfo = @"rest/userPhoneUpdate/validPersonInfo";
///换绑-->活体获取token
static NSString * const kPath_phoneUpdateGetToken = @"rest/userPhoneUpdate/getFaceToken";
///换绑-->活体人脸校验上传
static NSString * const kPath_phoneUpdateFaceVerify = @"rest/userPhoneUpdate/faceVerify";

///匿名换绑-->活体获取token
static NSString * const kPath_changePhoneUpdateGetToken = @"/rest/anon/getFaceToken";
///匿名换绑-->活体人脸校验上传
static NSString * const kPath_changePhoneUpdateFaceVerify = @"/rest/anon/faceVerify";


///微信绑定--查询
static NSString * const kPath_queryWxBindStatus = @"rest/weixin/queryWeixinBundlingStatus";
///微信信息--查询
static NSString * const kPath_queryWXInfo = @"rest/weixin/queryWeixinAuthorizationInfo";
///微信绑定
static NSString * const kPath_wxBind = @"rest/weixin/weixinBundling";
///微信解绑
static NSString * const kPath_wxUnbind = @"rest/weixin/weixinUnbundling";


///雇主信息 关键词搜索公司
static NSString * const kPath_searchByKeyWord = @"rest/company/listByKeyWord";

#pragma mark - 任务中心 -

///v1.6.0任务中心
static NSString * const kPath_taskCenter = @"rest/newUserInfo/queryTaskCenterInfo";
/////<v1.6.0任务中心
//static NSString * const kPath_taskCenter = @"rest/userInfo/getTaskCenter";

///额度资格评估
static NSString * const kPath_amountEvaluateInfo = @"/rest/newUserInfo/assessmentLimitNew";

static NSString * const kPath_uploadLocation = @"/rest/certificate/geographic";
static NSString *const kLastestUploadLocationDateKey = @"kLastestUploadLocationDateKey";
static NSString *const kActivityListLocationDateKey = @"kActivityListLocationDateKey";

///参考分图片上传
static NSString * const kPath_taskUploadImage = @"/rest/referScore/upload";
///参考分确认
static NSString * const kPath_taskScoreConfirm = @"/rest/referScore/confirm";

///流水邮箱
static NSString * const kPath_flowEmailDetail = @"/rest/certificate/getEmail";

///工资流水详情
static NSString * const kPath_wageDetail = @"rest/certWage/query";

///工资图片上传
static NSString * const kPath_wageImgUpload = @"/rest/certWageOcr/wageUpload";
///工资流水提交
static NSString * const kPath_wageSubmit =@"/rest/certWageOcr/submit";

#pragma mark - 消息 -

static NSString * const kPathMessageStatus = @"/rest/notice/record/newAppRecordStatus";
///已读更新
static NSString * const kPath_recordUpdate = @"rest/notice/record/update";

#pragma mark - 会员 -

///查询是否有会员购买资格
static NSString * const kPath_canBuyMember = @"rest/userInfo/queryCustomerQualification";

///会员等级
static NSString * const kPath_queryCustomerGrade = @"rest/loan/teller/queryCustomerGradeInfo";

///已开通会员列表
static NSString * const kPath_memberPayUserList = @"rest/loan/coupon/getCustomerPhone";
///创建会员 发送短信验证码
static NSString * const kPath_createMemberSmsCode = @"rest/loan/teller/quick/repayMembershipFee";

///创建会员 提交
static NSString * const kPath_memberPayConfirm = @"rest/loan/teller/quick/confirmToPay";


#pragma mark - 预支 -

///预支页面详情
static NSString * const GET_ADVANCE_SALARY_INFO_URL = @"/rest/loan/applyLoan";
///提交预支(创建贷款)
static NSString * const SUBMIT_LOAN_URL = @"/rest/loan/create";

///预支神券预支 发送银行卡验证码
static NSString * const kPath_advanceCoupon = @"/rest/trade/advanceCoupon/prepare";
///预支神券预支 确认支付
static NSString * const kPath_advanceCouponConfirm = @"/rest/trade/advanceCoupon/confirm";


#pragma mark -  优惠券列表 -
static NSString * const kCouponListPath = @"rest/commonCoupon/queryCustomerCouponList";


static NSString * const kMemberFeeCouponPath = @"rest/loan/coupon/calculate";

///新绑卡 发送验证码接口
static NSString * const kBankCardValidPath = @"/rest/bankCard/validate/prepareNew";


///根据银行卡号查询银行卡名称
static NSString * const kBankNameByNoPath = @"/rest/bankCard/getBankNameByNo";

///神券券规则
static NSString * const kPath_queryCouponRule = @"rest/loan/coupon/queryCouponRule";
///神券短信验证码
static NSString * const kPath_couponSmsCode = @"rest/loan/coupon/buyAdvanceCoupon";
///神券短信验证码
static NSString * const kPath_couponConfimToPay = @"rest/loan/coupon/confirmToPay";



#pragma mark -  提现 -

///提现详情
static NSString * const QUERY_WITHDRAW_INFO = @"/rest/loan/teller/withdrawInfo";
///提现
static NSString * const WITHDRAW_ACTION_URL = @"/rest/loan/teller/withdraw";

///发送验证码
static  NSString * const kPathSendVerifyCode = @"/rest/loan/teller/send/optCode";


#pragma mark - 分享、邀请 -
///分享详情
static NSString * const kShareInfoPath = @"rest/userRecommend/shareToThird";
///邀请页
static NSString * const USER_INVITE_DETAIL_URL = @"/rest/userRecommend/init";
///邀请记录
static NSString * const USER_INVITELIST_URL = @"/rest/userRecommend/listPage";
///海报信息
static NSString * const USER_QRCODE_URL = @"/rest/userRecommend/getUserQRCode";

#pragma mark - 银行卡 -
///校验是否能解绑并发送验证码
static NSString * const kPath_cardUnbindSendSmscode = @"rest/loan/checkBank";
///解绑
static NSString * const kPath_cardUnbindConfirm = @"rest/loan/unbundling";

#pragma mark - h5 path -
///客服 h5页面
static NSString * const kPath_myService = @"app/faq";

#pragma mark - mall -
///商城顶部banner商品
static NSString * const kPath_mallBanner = @"rest/market/initMarket";

///大汉-查看在售商品
static NSString * const kPath_onSaleGoodsList = @"rest/market/queryOnSaleProductList";

#pragma mark - 订单 -
///大汉-查看订单列表
static NSString * const kPath_orderList = @"rest/market/queryOrderRecordList";

#pragma mark - 埋点 -
///banner埋点
static NSString * const kPath_bannerAnalysis = @"rest/buryingPoint/add";


#endif /* ZXUrlAndPathHeader_h */
