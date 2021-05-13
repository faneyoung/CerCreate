//
//  URLRouter.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXBannerModel;

NS_ASSUME_NONNULL_BEGIN

/**
 URL路由参数
 */
typedef NS_ENUM(NSInteger, RouterOption) {
    
    RouterOption_New = 1 << 0,//添加新页面
    
    RouterOption_Existed = 1 << 1,//如果存在跳转到已存在界面 否则New
    
    RouterOption_Refresh = 1 << 2,//如果存在刷新该页面 否则New
    
    RouterOption_Close   = 1 << 3,//如果存在关闭当前页面
    
    RouterOption_Present   = 1 << 4,
    
    RouterOption_PresentNav   = 1 << 5,
};

///完整数据回调block
typedef void (^RouterBlock)(NSDictionary * _Nullable pms, id vc, id extra);

@interface RouterHandleModel : NSObject

@property (nonatomic, strong) UINavigationController *fromNav;
@property (nonatomic, assign) RouterOption routeOption;
///给vc的参数
@property (nonatomic, strong) NSDictionary *parameters;
///次要参数及回调结果
@property (nonatomic, strong) RouterBlock routerBlock;

@end

static inline RouterHandleModel * RouterHandleModelMake(UINavigationController * fromNav,RouterOption routeOption,NSDictionary * _Nullable parameters,RouterBlock resultBlock) {
    
    RouterHandleModel *blockModel = [[RouterHandleModel alloc]init];
    blockModel.fromNav = fromNav;
    blockModel.routeOption = routeOption;
    blockModel.parameters = parameters;
    blockModel.routerBlock = resultBlock;
    return blockModel;
}


@interface URLRouter : NSObject
+(instancetype)sharedInstance;


/// banner跳转
/// @param banner bannerModel
/// @param extra  extra parameters
+ (void)routerUrlWithBannerModel:(ZXBannerModel*)banner extra:(NSDictionary* _Nullable)extra;

+ (void)routerUrlWithPath:(NSString *)path extra:(NSDictionary * _Nullable)extra;
+ (void)routerUrlWithPath:(NSString *)path option:(RouterOption)options;
+ (void)routerUrlWithPath:(NSString *)path extra:(NSDictionary * _Nullable)extra outLink:(BOOL)outLink;

- (void)routerWithUrl:(NSURL*)url fromNav:(UINavigationController * _Nullable)fromNav parameters:(id _Nullable)pms option:(RouterOption)options;

+ (void)routeToMainPageTab;
+ (void)routeToTaskCenterTab;

+ (UIViewController *)currentRootViewController;
+ (UINavigationController *)currentNavigationController;

///推送处理
+ (void)routerRemoteNotification:(NSDictionary *)userInfo;

- (BOOL)actionWithUrl:(NSURL *)url extra:(NSDictionary *)extra complete:(void(^)(id result, NSError *error))completeBlock;


/// 分享
/// @param params 分享参数
- (void)shareAction:(NSDictionary *)params;

/// 是否安装了微信app
+ (BOOL)isWxInstalled;
///是否安装了支付宝
+ (BOOL)isAlipayInstalled;
/// 跳转到微信小程序支付分页面
/// @param completionBlock 完成block
+ (void)jumptoWXMiniProgramScoreCompletion:(void(^)(BOOL success))completionBlock;

@end

NS_ASSUME_NONNULL_END
