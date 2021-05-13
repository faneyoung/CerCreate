//
//  YJYZSDKDefine.h
//  YjyzVerify
//
//  Created by yjyz on 2019/5/17.
//  Copyright © 2019 yjyz. All rights reserved.
//

#ifndef YJYZSDKDefine_h
#define YJYZSDKDefine_h

/**
  结果的回调

 */
typedef void(^YjyzVerifyResultHander)(NSDictionary * _Nullable resultDic, NSError * _Nullable error);

typedef void(^YjyzVerifyCommonHander)(void);

#pragma mark - ********** Views *************

typedef NS_OPTIONS(NSUInteger, YJYZSDKLoginItemType) {
    
    YJYZSDKLoginItemTypeLogo = 1 << 0,       //一键验证Logo
    YJYZSDKLoginItemTypePhone = 1 << 1,      //一键验证电话号码
    YJYZSDKLoginItemTypeOtherLogin = 1 << 2, //一键验证其他登录方式
    YJYZSDKLoginItemTypeLogin = 1 << 3,      //一键验证登录
    YJYZSDKLoginItemTypePrivacy = 1 << 4,    //一键验证协议
    YJYZSDKLoginItemTypeSlogan = 1 << 5,     //一键验证底部描述
    YJYZSDKLoginItemTypeCheck = 1 << 6,      //一键验证复选框
};

#pragma mark - ********** 横竖屏状态 *************

//一键验证当前的屏幕状态
typedef NS_ENUM(NSInteger, YJYZScreenStatus) {
    //竖屏
    YJYZScreenStatusPortrait = 0,
    //横屏
    YJYZScreenStatusLandscape,
};


#endif /* YJYZSDKDefine_h */
