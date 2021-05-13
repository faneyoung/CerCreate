//
//  ZXGoodsModel.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXGoodsModel : ZXBaseModel

///商品类型（1-实物，2-卡密订购，3-账户直充，4-卡密和直充）实物商品与虚拟商品不可同时购买
@property (nonatomic, strong) NSString *type;
/// 上下架状态，0-下架，1-上架
@property (nonatomic, strong) NSString *onSale;
/// 商品sku标识id
@property (nonatomic, strong) NSString *skuId;
///商品id
@property (nonatomic, strong) NSString *productId;

// 商品名称
@property (nonatomic, strong) NSString *commodityName;
@property (nonatomic, strong) NSString *commodityNumber;

/// 商品描述
@property (nonatomic, strong) NSString *commodityDetail;
/// 展示图片
@property (nonatomic, strong) NSString *showMages;

///展示金额，格式化过的字符串
@property (nonatomic, strong) NSString *showAmount;

///商品来源（1-自营，2-京东）
@property (nonatomic, strong) NSString *source;
/// 产地
@property (nonatomic, strong) NSString *productPlace;
/// 分类id
@property (nonatomic, strong) NSString *classifyId;
///  分类名称
@property (nonatomic, strong) NSString *classifyName;
///true：隐藏；false：不隐藏； 默认false
@property (nonatomic, assign) BOOL hideTitle;

/// 跳转url
@property (nonatomic, strong) NSString *targetUrl;


@property (nonatomic, assign) BOOL showBlankView;


@property (nonatomic, strong) NSArray *mockItems;

@end

NS_ASSUME_NONNULL_END

/**
 {
     "skuId":,           // 商品sku标识id
     "type":,            // 商品类型（1-实物，2-卡密订购，3-账户直充，4-卡密和直充）实物商品与虚拟商品不可同时购买
     "onSale":,          // 上下架状态，0-下架，1-上架
     "commodityName":"",   // 商品名称
     "commodityDetail":"", // 商品描述
     "commodityBrand":"",  // 品牌
     "showPrice":"",       // 展示价格
     "listPrice":"",       // 商品结算价格
     "showMages":"",       // 展示图片
     "source":,          // 商品来源（1-自营，2-京东）
     "productPlace":"",    // 产地
     "classifyId":"",      // 分类id
     "classifyName":""     // 分类名称
 }

 */
