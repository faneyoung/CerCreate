//
//  URLRouterHeader.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef URLRouterHeader_h
#define URLRouterHeader_h

#pragma mark Block
typedef void(^RouterCompleteBlock)(id result, NSError *error);

//完整url格式 @"zxsd://zxsd.com/memberMessage"

static NSString * const kURLParam_needLogin        = @"needLogin";

///分享
static NSString * const kURLRouter_Share    = @"share";

#pragma mark - 流程相关 -

/// 选择公司 雇主检查 手机号切换
static NSString * const kRouter_existNote = @"existNote";

/// 新用户绑卡
static NSString * const kRouter_bindCard = @"PREPARE_BANKCARD";
/// 填写雇主信息
static NSString * const kRouter_bindEmployerInfo = @"bindEmployerInfo";

/// 上传身份证
static NSString * const kRouter_idCardUpload = @"idCardUpload";
/// 人脸认证
static NSString * const kRouter_liveFace = @"liveFace";

/// 开通会员费
static NSString * const kRouter_openMemberFee = @"openMemberFee";

/// 雇主信息查询
static NSString * const kRouter_companyInfoQuery = @"companyInfoQuery";
/// 公司搜索
static NSString * const kRouter_companySearch = @"companySearch";

///推荐工作
static NSString * const kRouter_recommendWork = @"RECOMMENDED_WORK";

#pragma mark - 预支 -
static NSString * const kRouter_advancePage = @"CAN_ADVANCE";

#pragma mark - 消息 -
/// 消息-主页
static NSString * const kURLRouter_messageMain = @"messageMain";

/// 消息-会员
static NSString * const kURLRouter_memberMessage = @"memberMessage";

#pragma mark - 会员 -
///会员中心
static NSString * const kURLRouter_memberCenter = @"memberCenter";

#pragma mark - 个人中心 -
///设置
static NSString * const kRouter_setting = @"setting";
/// 个人资料
static NSString * const kRouter_mineProfile = @"mineProfile";
///工资卡管理
static NSString * const kRouter_cardManageList = @"cardManageList";
///预支记录
static NSString * const kRouter_advanceRecords = @"advanceRecords";
///任务中心
static NSString * const kRouter_taskCenter = @"taskCenter";
///邀请好友
static NSString * const kRouter_inviteFriends = @"inviteFriends";
///邀请我司
static NSString * const kRouter_inviteCompany = @"inviteCompany";
///身份信息
static NSString * const kRouter_idCardInfo = @"idCardInfo";
///雇主信息
static NSString * const kRouter_companyInfo = @"companyInfo";
///关于
static NSString * const kRouter_about = @"about";
///账户安全
static NSString * const kRouter_accountSecurity = @"accountSecurity";
///账户安全--->修改手机号
static NSString * const kRouter_modifyPhone = @"modifyPhone";

///账户安全--->新旧手机号
static NSString * const kRouter_modifyPhoneInfo = @"modifyPhoneInfo";


#pragma mark - 任务中心 -
///个人信息
static NSString * const kRouter_personInfo = @"personInfo";
///联系人
static NSString * const kRouter_contract = @"contract";
///工资明细
static NSString * const kRouter_salaryInfo = @"salaryInfo";
///消费明细
static NSString * const kRouter_consumeInfo = @"consumeInfo";
///上传结果
static NSString * const kRouter_uploadDetailResult = @"uploadDetailResult";

///信用分上传页
static NSString * const kRouter_scoreUpload = @"scoreUpload";

///额度资格评估
static NSString * const kRouter_amountEvaluation = @"amountEvaluation";

///银行收入明细 上传
static NSString * const kRouter_bankIncomeUpload = @"bankIncomeUpload";

#pragma mark - order -
///订单列表
static NSString * const kRouter_orderPage = @"orderPage";

#pragma mark - action -
///评价
static NSString * const kRouter_evaluation = @"evaluation";


#pragma mark - 优惠券 -
/// 优惠券列表
static NSString * const kRouter_couponList = @"coupon";
/// 选择优惠券
static NSString * const kRouter_couponSelection = @"couponSelection";

///预支神券购买
static NSString * const kRoute_buyCoupon = @"BUY_COUPON";

#endif /* URLRouterHeader_h */
