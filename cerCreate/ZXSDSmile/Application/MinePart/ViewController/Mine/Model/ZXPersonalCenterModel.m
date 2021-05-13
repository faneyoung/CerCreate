//
//  ZXPersonalCenterModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXPersonalCenterModel.h"

@implementation ZXPersonalCenterModel

/**
 NSArray *section0 = @[
     @{@"icon":@"mine_pay", @"title":@"预支记录"},
     @{@"icon":@"icon_mine_coupon", @"title":@"优惠券"},

 ];
 
 NSArray *section1 = @[
     @{@"icon":@"mine_idcard", @"title":@"身份信息"},
     @{@"icon":@"mine_banckcard", @"title":@"工资卡管理"},
     @{@"icon":@"mine_company", @"title":@"雇主信息"},
     @{@"icon":@"mine_manage", @"title":@"任务中心"}
 ];
 
 NSArray *section2 =  nil;
 BOOL showInviteCompany = ![[ZXSDCurrentUser currentUser].userRole isEqualToString:@"smile"];
 if (showInviteCompany) {
     section2 = @[
         @{@"icon":@"mine_friends", @"title":@"邀请好友"},
         @{@"icon":@"mine_invite", @"title":@"邀请我司"}
     ];
 } else {
     section2 = @[
         @{@"icon":@"mine_friends", @"title":@"邀请好友"}
     ];
 }
 
 NSArray *section3 = @[
     @{@"icon":@"mine_faq", @"title":@"帮助与客服"},
     @{@"icon":@"mine_contact_ceo", @"title":@"留言联系 CEO"}
 ];
 
 NSArray *totalConfigs = @[section0,section1,section2, section3];

 */

+ (instancetype)instanceWithTitle:(NSString*)title icon:(NSString*)imgName action:(NSString*)action{
    
    return [ZXPersonalCenterModel instanceWithTitle:title icon:imgName desc:nil action:action];
}

+ (instancetype)instanceWithTitle:(NSString*)title icon:(NSString*)imgName desc:(NSString *)desc action:(NSString*)action{
    
    return [ZXPersonalCenterModel instanceWithTitle:title icon:imgName desc:desc action:action needVerify:NO];
}

+ (instancetype)instanceWithTitle:(NSString*)title icon:(NSString*)imgName desc:(NSString *)desc action:(NSString*)action needVerify:(BOOL)needVerify{
    ZXPersonalCenterModel *model = [[ZXPersonalCenterModel alloc] init];
    model.title = title;
    model.icon = imgName;
    model.desc = GetString(desc);
    model.action = action;
    model.needVerify = needVerify;
    return model;
}

//- (void)test{
//    if ([model.title isEqualToString:@"预支记录"]) {
//        ZXSDAdvanceRecordsController *viewController = [ZXSDAdvanceRecordsController new];
//        [self.navigationController pushViewController:viewController animated:YES];
//    } else if ([model.title isEqualToString:@"身份信息"]) {
//        TrackEvent(kMine_info);
//
//        ZXSDQueryIDCardInfoController *viewController = [ZXSDQueryIDCardInfoController new];
//        [self.navigationController pushViewController:viewController animated:YES];
//    } else if ([model.title isEqualToString:@"工资卡管理"]) {
//
//        //ZXSDQueryDebitCardInfoController *viewController = [ZXSDQueryDebitCardInfoController new];
//        ZXSDBankCardListController *viewController = [ZXSDBankCardListController new];
//        [self.navigationController pushViewController:viewController animated:YES];
//    } else if ([model.title isEqualToString:@"雇主信息"]) {
//        ZXSDQueryCompanyInfoController *viewController = [ZXSDQueryCompanyInfoController new];
//        [self.navigationController pushViewController:viewController animated:YES];
//    } else if ([model.title isEqualToString:@"任务中心"]) {
//
//        ZXSDCertificationCenterController *viewController = [ZXSDCertificationCenterController new];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }  else {
//        ZGLog(@"用户中心点击异常!");
//    }
//
//}

+ (NSArray*)personalCenterItems{
    NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:3];
    
    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"预支记录" icon:@"mine_pay" desc:nil action:kRouter_advanceRecords needVerify:YES],
        /*[ZXPersonalCenterModel instanceWithTitle:@"任务中心" icon:@"mine_manage" desc:nil action:kRouter_taskCenter needVerify:YES],*/
    ]];

    NSString *userSession = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSSESSION];
    NSMutableDictionary *inviteDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [inviteDic setSafeValue:userSession forKey:@"session"];
    NSString *coopUrl = WebPageUrlFormatter(kPath_partner, inviteDic.copy);
    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"合伙人计划" icon:@"mine_friends" action:coopUrl],
        /*[ZXPersonalCenterModel instanceWithTitle:@"邀请我司" icon:@"mine_invite" desc:nil action:kRouter_inviteCompany needVerify:YES],*/
    ]];

    NSString *help = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/faq"];
    NSString *feedback = [NSString stringWithFormat:@"%@%@", H5_WEB, @"/app/feedback"];
    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"帮助与客服" icon:@"mine_faq" action:help],
        [ZXPersonalCenterModel instanceWithTitle:@"留言联系 CEO" icon:@"mine_contact_ceo" action:feedback],
    ]];
    
    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"设置" icon:@"mine_setting" action:kRouter_setting],
    ]];

    
    return tmps.copy;
}

+ (NSArray*)personalProfileItems{
    NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:3];
    
    
    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"身份信息" icon:@"mine_idcard" desc:nil action:kRouter_idCardInfo needVerify:YES],
        /*[ZXPersonalCenterModel instanceWithTitle:@"雇主信息" icon:@"mine_company" desc:nil action:kRouter_companyInfo needVerify:YES],*/
    ]];


    int payday = [ZXSDCurrentUser currentUser].payDay;
    NSString *paydayStr = [NSString stringWithFormat:@"每月 %d 日",payday] ;

    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"发薪日" icon:@"icon_mine_payday" desc:paydayStr action:nil],
    ]];

    
    return tmps.copy;
}

+ (NSArray*)personalSettingItems{
    NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:3];
    
    
    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"账户安全" icon:@"icon_setting_safe" desc:nil action:kRouter_accountSecurity needVerify:NO],
        [ZXPersonalCenterModel instanceWithTitle:@"关于" icon:@"icon_setting_about" desc:nil action:kRouter_about needVerify:NO],
        [ZXPersonalCenterModel instanceWithTitle:@"去评价" icon:@"icon_setting_comment" desc:nil action:kRouter_evaluation needVerify:NO],

    ]];


    NSString *flag = @"";
    NSString *buildVersionStr = @"";
#if TEST
    flag = @"-test";
    buildVersionStr = [NSString stringWithFormat:@"(build %@)",appBuildVersion()];
#elif UAT
    flag = @"-UAT";
    buildVersionStr = [NSString stringWithFormat:@"(build %@)",appBuildVersion()];

#elif RELEASE
    flag = @"";
    if ([kSourceChannel isEqualToString:@"enterprise"]) {
        buildVersionStr = [NSString stringWithFormat:@"(%@)",appBuildVersion()];
    }
#endif
   NSString *version  = [NSString stringWithFormat:@"v%@%@%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],buildVersionStr,flag];

    [tmps addObject: @[
        [ZXPersonalCenterModel instanceWithTitle:@"版本号" icon:@"icon_setting_version" desc:version action:nil],
    ]];

    
    return tmps.copy;
}

+ (NSArray*)personalAcountSecurityItems{
    NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:3];
    
    
//    [tmps addObject: @[
//        [ZXPersonalCenterModel instanceWithTitle:@"身份信息" icon:@"mine_idcard" desc:nil action:kRouter_idCardInfo needVerify:YES],
//        [ZXPersonalCenterModel instanceWithTitle:@"雇主信息" icon:@"mine_company" desc:nil action:kRouter_companyInfo needVerify:YES],
//    ]];

    
    return tmps.copy;
}


@end
