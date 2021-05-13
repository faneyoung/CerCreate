//
//  ZXSDCurrentUser.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/23.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXSDCompanyModel.h"

#import "ZXUserModel.h"
#import "ZXSDHomeLoanInfo.h"

/**
 员工信息查询
​ EMPLOYEE_QUERY,
​ 雇主审核
​ EMPLOYER_APPROVE;
*/
typedef enum : NSUInteger {
    ZXSDCooperationModelNone = 0,
    ZXSDCooperationModelEmployerApprove = 1,
    ZXSDCooperationModelEmployerQuery = 2
} ZXSDCooperationModel;


NS_ASSUME_NONNULL_BEGIN

@interface ZXSDCurrentUser : NSObject

@property (nonatomic, strong) ZXUserModel *userModel;
@property (nonatomic, strong) ZXSDHomeLoanInfo *homeLoanInfo;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign, getter=isSmilePlus) BOOL smilePlus; //是合作企业用户
@property (nonatomic, assign) BOOL canEditJobInfo;

@property (nonatomic, copy) NSString *customerValidity; // 会员有效期

// smile:合作企业用户(但是未必认证完成); normal:非合作企业用户
@property (nonatomic, copy) NSString *userRole; 
@property (nonatomic, assign) BOOL isOldUser;

/** 审核中
​    SUBMIT("Submit", "审核中"),
​    审核拒绝
​    REJECT("Reject", "审核拒绝"),
​    审核通过
​    ACCEPT("Accept", "审核通过");
*/
@property (nonatomic, copy) NSString *smileStatus;

// 四要素认证是否已经完成
@property (nonatomic, assign) BOOL isCertified;

// 当前用户的分享海报
@property (nonatomic, copy) NSString *shareQRURL;

//是否确定了雇主
@property (nonatomic, assign) BOOL selectedCompany;
//是否已绑定员工信息
@property (nonatomic, assign) BOOL confrimedEmployee;
//是否需要绑定银行卡
@property (nonatomic, assign) BOOL bindBankCard;
@property (nonatomic, strong, nullable) ZXSDCompanyModel *company;
@property (nonatomic, assign) int payDay;


/// 首页用户点击头部认证noteView标记。默认为false，点击过以后变为true
@property (nonatomic, assign) BOOL userHideNote;
/// 上传支付分页面标记。默认为false，点击过以后变为true
@property (nonatomic, assign) BOOL userHideScoreNoteWX;
@property (nonatomic, assign) BOOL userHideScoreNoteAli;

@property (nonatomic, assign) BOOL userHideScoreUploadNoteWX;
@property (nonatomic, assign) BOOL userHideScoreUploadNoteAli;

@property (nonatomic, assign) BOOL userHideAmountEvaluateNote;
@property (nonatomic, assign) BOOL userHideWageUploadNote;


@property (nonatomic, assign, readonly) ZXSDCooperationModel businessModel;

+ (BOOL)isLogin;
+ (instancetype)currentUser;
- (void)updateCurrentUser:(id)info;
- (void)updateUser:(ZXUserModel*)userModel;

+ (void)clearUserInfo;
+ (void)registerAliasForJPush;

+ (void)logout;

- (void)queryUserEmployerInfo:(void(^)(BOOL selectedCompany, BOOL confrimedEmployee, BOOL bindBankCard, NSURLSessionDataTask * _Nullable task, NSError *error))completed;

- (BOOL)checkAllAuthStatusWithBackVC:(UIViewController*)vc;
- (BOOL)checkFourStepAuthStatus:(UIViewController*)vc;
- (BOOL)checkActionWithStatus:(NSArray*)status backVC:(UIViewController*)vc;

@end

NS_ASSUME_NONNULL_END
