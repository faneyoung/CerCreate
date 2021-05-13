//
//  YJYZSDKManager.h
//  YjyzVerify
//
//  Created by yjyz on 2019/11/29.
//  Copyright © 2019 yjyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YJYZSDKDefine.h"
#import "YJYZUIModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJYZSDKManager : NSObject

#pragma mark - ******* 授权页面视图元素 ********

//授权页VC
+ (UIViewController *)yjyzAuthViewController;

//logo视图
+ (UIImageView *)yjyzLogoView;

//手机号码视图
+ (UILabel *)yjyzPhoneView;

//登录按钮视图
+ (UIButton *)yjyzLoginView;

//其他登录方式
+ (UIButton *)yjyZotherLoginView;

//Slogan标签视图
+ (UILabel *)yjyzSloganView;

//隐私条款视图
+ (UITextView *)yjyzPrivacyView;

//隐私条款check视图
+ (UIButton *)yjyzPrivacyCheckView;

//默认授权页背景图片
+ (UIImageView *)yjyzDefaultBgImageView;

//弹窗背景视图
+ (UIView *)yjyzAlertBgView;

//左上角视图
+ (UIButton *)yjyzAlertLeftView;

//右上角视图
+ (UIButton *)yjyzAlertRightView;

//弹窗背景图片
+ (UIImageView *)yjyzAlertBgImageView;


#pragma mark - ******* util ********
/**
 显示loading 视图
 适用于自定义事件，需要在登录界面显示loading场景
 */
+ (void)yjyzShowLoadingView;

/**
 隐藏loading 视图
 适用于自定义事件，需要在登录界面隐藏loading场景
 */
+ (void)yjyzHideLoadingView;

/**
 控制子视图显隐
 
 @param item item子视图
 @param hide 是否隐藏
 */
+ (void)yjyzHideAuthView:(YJYZSDKLoginItemType)item hide:(BOOL)hide;


/**
 LoginVc是否响应事件
 
 */
+ (void)yjyzSetLoginVCEnable:(BOOL)enable;

/*
 适用于手动关闭场景下
 需要重新点击登录按钮
 */
+ (void)yjyzReLoginVCEnable;

/**
 获取当前屏幕状态
 
 */
+ (void)yjyzGetAuthScreenStatus:(void(^)(YJYZScreenStatus status, CGSize size))status;


//登录页面协议富文本
+ (NSMutableAttributedString *)loginProtocolAttrStr:(YJYZUIModel *)customModel;

//登录页面协议size
+ (CGSize)loginProtocolSize:(YJYZUIModel *)customModel maxWidth:(float)maxWidth;

@end

NS_ASSUME_NONNULL_END
