//
//  ZXOrderListModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"
#import "ZXGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXOrderListModel : ZXBaseModel

///订单号
@property (nonatomic, strong) NSString *orderNo;
///订单编号，自己平台的订单号。对于福禄订单没有orderNo，取refId作为订单号
@property (nonatomic, strong) NSString *refId;

@property (nonatomic, strong) NSString *orderDetailsId;

/// 订单状态 0:待支付 1已支付 2已退单
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusStr;

@property (nonatomic, strong) NSString *image;
/// 商品名称
@property (nonatomic, strong) NSString *commodityName;
/// 总价
@property (nonatomic, strong) NSString *total;
/// dahan-大汉 fulu-福禄
@property (nonatomic, strong) NSString *channel;
///订单详情url
@property (nonatomic, strong) NSString *orderDetailUrl;
///收银台url
@property (nonatomic, strong) NSString *cashierUrl;

///失效时间
@property (nonatomic, strong) NSString *expires;
///// 创建时间
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *formatterTime;


@property (nonatomic, strong) NSString *bankNo;
@property (nonatomic, strong) NSString *bankIcon;

@property (nonatomic, strong) NSArray *goodsList;


@end

NS_ASSUME_NONNULL_END

/**
 "refId":"",             // 订单编号
 "userRefId":"",         // 用户编号
 "skuId":,             // 商品sku标识id
 "orderDetailsId":,    // 订单详情Id
 "orderNo":"",           // 订单号
 "commodityName":"",     // 商品名称
 "listPrice":"",         // 商品结算价格
 "count":,             // 数量
 "total":,             // 总价
 "status":"",            // 订单状态 0:待支付 1已支付 2已退单
 "expires":""            // 失效时间

 */
