//
//  UITableView+help.h
//  wlive
//
//  Created by fane on 2020/6/27.
//  Copyright © 2020 xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
@class ZXPlaceholderView;

@interface UITableView (help)

///占位图偏移量
@property (nonatomic, assign) float centery;

///初始是否显示占位图
@property (nonatomic, assign) BOOL showPlaceholdWhenLoad;
///占位图
@property (nonatomic,strong) UIView *placeholderView;
@property (nonatomic, strong) UIImage *placeholderImage;


///空白页点击事件
@property (nonatomic,copy) void(^reloadBlock)(void);

- (UIView*)defaultPlaceholdViewWithMsg:(NSString *_Nullable)msg;
- (UIView*)defaultPlaceholdViewWithMsg:(NSString *_Nullable)msg subTitle:(NSString *)subTitle;

-(void)registerNibs:(NSArray *)nibArr;
-(void)registerClasses:(NSArray *)classes;

///添加上下拉刷新
- (void)addHeaderRefreshingBlock:(void(^)(void))refreshBlock;
- (void)addFooterRefreshingBlock:(void(^)(void))refreshBlock;
- (void)startHeaderRefresh;
- (void)endHeaderFooterAnimation;
///默认cell
- (UITableViewCell *)defaultReuseCell;

/// 占位view
- (UIView*)commonPlaceholderView;

///分割线
- (UIView*)sepFooterView;

///分组头&脚
- (UIView*)defaultHeaderFooterView;

@end

NS_ASSUME_NONNULL_END
