//
//  ZXTrackHeader.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef ZXTrackHeader_h
#define ZXTrackHeader_h

/**
 推送点击
 */
static NSString * const kTrackRemoteNotificationClickEvent = @"remoteNotificationClicked";

//登录注册
static NSString * const kOnekeyLoginPage = @"onekeyLoginPage";///一键登录页
static NSString * const kOnekeyLogin = @"onekeyLogin";///一键登录
static NSString * const kPhoneLoginInputPage = @"phoneLoginInputPage";///手机号登录页
static NSString * const kSmscodeLoginPage = @"smscodeLoginPage";///验证码登录页
static NSString * const kSmscodeLogin = @"smscodeLogin";///验证码登录
static NSString * const kWeixinLogin = @"weixinLogin";///微信登录

//home
static NSString * const kHomePage = @"homePage";///首页
static NSString * const ksalaryFriendAcademyPage = @"salaryFriendAcademyPage";///薪朋友学院


static NSString * const kquestionList  = @"questionList"; ///常见问题/热点问题列表
static NSString * const kquestionItem  = @"questionItem"; ///常见问题/哪些人可以申请提前预支工资的服务
static NSString * const kAuth_idCard  = @"auth_idCard"; ///认证-上传身份证
static NSString * const kAuth_face  = @"auth_face"; ///认证-刷脸
static NSString * const kAuth_bankCard  = @"auth_bankCard"; ///认证-绑定银行卡
static NSString * const kAuth_jobInfo  = @"auth_jobInfo"; ///认证-填写工作信息
static NSString * const kAdvance_uploadRisk  = @"advance_uploadRisk"; ///立即预支-提交风控
static NSString * const kAdvance_risk_underRevice  = @"advance_risk_underRevice"; ///立即预支-风控审核中
static NSString * const kAdvance_risk_refused  = @"advance_risk_refused"; ///立即预支-风控审核拒绝
static NSString * const kAdvance_employer_underRevice  = @"advance_employer_underRevice"; ///立即预支-雇主审核中
static NSString * const kAdvance__employer_refused  = @"advance__employer_refused"; ///立即预支-雇主审核拒绝
static NSString * const kAdvance_advancing  = @"advance_advancing"; ///立即预支-预支中
static NSString * const kAdvance_enable  = @"advance_enable"; ///立即预支-能预支
static NSString * const kAdvance_disable  = @"advance_disable"; ///立即预支-不能预支
static NSString * const kAdvance_refund  = @"advance_refund"; ///立即预支-立即还款
static NSString * const kAdvance_refund_overdue  = @"advance_refund_overdue"; ///立即预支-逾期还款
static NSString * const kPayMemberFee  = @"payMemberFee"; ///支付会员费
static NSString * const kMinePage  = @"minePage"; ///我的
static NSString * const kSettingPage  = @"settingPage"; ///设置
static NSString * const kAdvancedRecord  = @"advancedRecord"; ///预支记录
static NSString * const kExtension  = @"extension"; ///展期
static NSString * const kAdvancedRecord_refund  = @"advancedRecord_refund"; ///立即还款
static NSString * const kMine_info  = @"mine_info"; ///身份信息
static NSString * const kMine_bankCard  = @"mine_bankCard"; ///工资卡管理
static NSString * const kMine_employer_msg  = @"mine_employer_msg"; ///雇主信息
static NSString * const ktaskCenterList  = @"taskCenterList"; ///任务中心列表
static NSString * const ktask_personalInformation  = @"task_personalInformation"; ///任务中心-个人信息
static NSString * const kContacts  = @"task_contacts"; ///任务中心-常用联系人
static NSString * const kSalary  = @"task_salary"; ///任务中心-工资明细
static NSString * const kExpenseDetail  = @"task_expenseDetail"; ///任务中心-消费明细
static NSString * const kLocation  = @"task_location"; ///任务中心-位置
static NSString * const kInvitation  = @"mine_invitation"; ///邀请新用户
static NSString * const kInvite_me  = @"mine_invite_me"; ///邀请我司
static NSString * const kNote_ceo  = @"mine_note_ceo"; ///留言ceo


 


#endif /* ZXTrackHeader_h */
