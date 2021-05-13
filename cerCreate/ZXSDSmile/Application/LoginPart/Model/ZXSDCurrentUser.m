//
//  ZXSDCurrentUser.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/23.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCurrentUser.h"
#import "JPUSHService.h"


static const NSString *USER_EMPLOYERINFO_URL = @"/rest/company/user";

@implementation ZXSDCurrentUser

+ (instancetype)currentUser
{
    static ZXSDCurrentUser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZXSDCurrentUser new];
        instance.canEditJobInfo = YES;
        if ([ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID]) {
            instance.phone = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
        }
        
    });
    return instance;
}

- (void)updateCurrentUser:(id)info{
    
    ZXSDHomeLoanInfo *loanInfo = (ZXSDHomeLoanInfo*)info;
    self.homeLoanInfo = loanInfo;
    
    self.canEditJobInfo = loanInfo.extraInfo.canEditJobInfo;
    self.customerValidity = loanInfo.extraInfo.customerValidity;
    self.isOldUser = loanInfo.extraInfo.isOldUser;
    self.userRole = loanInfo.extraInfo.userRole;
    self.isCertified = loanInfo.extraInfo.isCertified;
    self.company.cooperationModel = loanInfo.extraInfo.cooperationModel;
    self.smileStatus = loanInfo.extraInfo.smileStatus;
    
    if ([loanInfo.extraInfo.userRole isEqualToString:@"smile"]) {
        self.smilePlus = YES;
    }
    
    self.payDay = (int)loanInfo.loanModel.payDay;
}

#pragma mark - help methods -

+ (BOOL)isLogin
{
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
    if (CHECK_VALID_STRING(userSession) && CHECK_VALID_STRING(userId)) {
        return YES;
    }
    return NO;
}
///退出登录
+ (void)logout{
    // 清空用户数据
    [ZXSDCurrentUser clearUserInfo];

    [[NSNotificationCenter defaultCenter] postNotificationName:ZXSD_NOTIFICATION_USERLOGOUT object:nil];
}
///清除用户信息
+ (void)clearUserInfo
{
    NSString *userLocKey = [NSString stringWithFormat:@"k%@UserLocDic",[ZXSDCurrentUser currentUser].phone];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:userLocKey];

    [ZXSDCurrentUser currentUser].phone = @"";
    [ZXSDCurrentUser currentUser].canEditJobInfo = YES;
    [ZXSDCurrentUser currentUser].smilePlus = NO;
    [ZXSDCurrentUser currentUser].isOldUser = NO;
    [ZXSDCurrentUser currentUser].isCertified = NO;
    [ZXSDCurrentUser currentUser].shareQRURL = @"";
    [ZXSDCurrentUser currentUser].customerValidity = @"";
    [ZXSDCurrentUser currentUser].userRole = @"";
    
    [ZXSDCurrentUser currentUser].selectedCompany = NO;
    [ZXSDCurrentUser currentUser].confrimedEmployee = NO;
    [ZXSDCurrentUser currentUser].bindBankCard = NO;
    [ZXSDCurrentUser currentUser].company = nil;
    [ZXSDCurrentUser currentUser].userModel = nil;

    NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
    NSString *key = [NSString stringWithFormat:@"%@_%@", USER_INITIAL_COMPANY_OTHER, userId];
    [ZXSDUserDefaultHelper removeObjectForKey:key];
    
    
    [ZXSDUserDefaultHelper removeObjectForKey:KEEPLOGINSTATUSUSERID];
    [ZXSDUserDefaultHelper removeObjectForKey:KEEPLOGINSTATUSSESSION];
    [ZXSDPublicClassMethod deleteAllCookiesInSharedHTTPCookieStorage];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        ZGLog(@"deleteAlias....%@...%@", iAlias, @(iResCode));
    } seq:0];
}

///登录极光
+ (void)registerAliasForJPush
{
    NSString *phone = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
    if (!CHECK_VALID_STRING(phone)) {
        return;
    }
    [JPUSHService setAlias:phone
                completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        ZGLog(@"setAlias....%@...%@", iAlias, @(iResCode));
    } seq:0];
}

- (void)queryUserEmployerInfo:(void(^)(BOOL selectedCompany, BOOL confrimedEmployee, BOOL bindBankCard, NSURLSessionDataTask * _Nullable task, NSError *error))completed
{
    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
    if (!CHECK_VALID_STRING(userSession) || !CHECK_VALID_STRING(userId)) {
        
        if (completed) {
            completed(NO, NO, NO, nil, nil);
        }
        return;
    }
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,USER_EMPLOYERINFO_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"用户雇主信息返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.selectedCompany = [[responseObject objectForKey:@"selectedCompany"] boolValue];
            self.confrimedEmployee = [[responseObject objectForKey:@"confrimedEmployee"] boolValue];
            self.bindBankCard = [[responseObject objectForKey:@"bindBankCard"] boolValue];
            
            self.company = [ZXSDCompanyModel modelWithJSON:[responseObject objectForKey:@"company"]];
//#warning --test--
//            self.company.cooperationModel = @"0";
//#warning --test--

        }
        
        if (completed) {
            completed(self.selectedCompany, self.confrimedEmployee, self.bindBankCard, task ,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completed) {
            completed(NO, NO, NO, task, error);
        }
    }];
}

- (ZXSDCooperationModel)businessModel
{
    ZXSDCooperationModel model = ZXSDCooperationModelEmployerApprove;
    if ([self.company.cooperationModel isEqualToString:@"EMPLOYER_APPROVE"]) {
        model = ZXSDCooperationModelEmployerApprove;
    } else if ([self.company.cooperationModel isEqualToString:@"EMPLOYEE_QUERY"]) {
        model = ZXSDCooperationModelEmployerQuery;
    }
    return model;
}

#pragma mark - auth -
- (BOOL)checkAllAuthStatusWithBackVC:(UIViewController*)vc{
    NSArray *status = @[
        /*ZXSDHomeUserApplyStatus_IDCARD_UPLOAD,
        ZXSDHomeUserApplyStatus_PREPARE_FACE,*/
        ZXSDHomeUserApplyStatus_PREPARE_BANKCARD,
        ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO,
        /*ZXSDHomeUserApplyStatus_TASK_CENTER,*/
    ];
    return [self checkActionWithStatus:status backVC:vc];

}

- (BOOL)checkFourStepAuthStatus:(UIViewController*)vc{
    NSArray *status = @[
        ZXSDHomeUserApplyStatus_IDCARD_UPLOAD,
        ZXSDHomeUserApplyStatus_PREPARE_FACE,
        ZXSDHomeUserApplyStatus_PREPARE_BANKCARD,
        ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO,
    ];
    return [self checkActionWithStatus:status backVC:vc];
}

- (BOOL)checkActionWithStatus:(NSArray*)status backVC:(UIViewController*)vc{
    if (!IsValidArray(status)) {
        return NO;
    }
    
    ZXUserModel *userModel = self.userModel;
    if (!userModel) {
        return YES;
    }
    NSDictionary *params = @{};
    if (vc) {
       params = @{@"backViewController":vc};
    }

   __block BOOL check = NO;
    [status enumerateObjectsUsingBlock:^(NSString*  _Nonnull sta, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([userModel.actionStatus isEqualToString: sta]) {
            if ([sta isEqualToString: ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]) {
                [URLRouter routerUrlWithPath:kRouter_idCardUpload extra:params];
                check = YES;
                *stop = YES;
                    
            } else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_FACE]) {
                [URLRouter routerUrlWithPath:kRouter_liveFace extra:params];
                check = YES;
                *stop = YES;

                
            } else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_BANKCARD]) {
                [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];

                check = YES;
                *stop = YES;


            } else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_JOB_INFO]) {
                [URLRouter routerUrlWithPath:kRouter_bindEmployerInfo extra:nil];

                check = YES;
                *stop = YES;


            }
            /*else if ([sta isEqualToString: ZXSDHomeUserApplyStatus_TASK_CENTER]) {
                [URLRouter routeToTaskCenterTab];
                check = YES;
                *stop = YES;

            }*/

        }


    }];
    
    return check;
}


@end
