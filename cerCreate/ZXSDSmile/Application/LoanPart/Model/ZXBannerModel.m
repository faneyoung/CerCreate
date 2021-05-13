//
//  ZXBannerModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBannerModel.h"

@implementation ZXBannerModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"cover" : @"picUrl",
        @"url" : @"targetUrl",
        @"desc" : @[@"desc",@"description"],
        @"needLogin" : @[@"needLogin",@"isNeedLogin"],
        @"linkFlag" : @[@"linkFlag",@"isLinkFlag"],
        @"isHideTitle": @[@"hideTitle",@"isHideTitle"],
    };
}

@end

@implementation ZXHomeBannerModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"list" : @[@"list",@"bannerList",@"virtualProductList"],
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"list":ZXBannerModel.class,
    };
}


+ (ZXHomeBannerModel *)mockItemWithType:(NSString*)type{
    
    NSArray *imgs = @[
    
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F017dfd55e1437b6ac7251df8a7ebfc.jpg%40900w_1l_2o_100sh.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621494707&t=8019229e63ea4c9b94af2b04c0beb492",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d56b5542d8bc0000019ae98da289.jpg%401280w_1l_2o_100sh.png&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621494707&t=2b29e97362010a5f51c9e2fa5e471d67",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c4bc5534a402000000684de4e822.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621494707&t=be2185200ffbc316672ced991422218b",
        /*@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f34459b7972ca801211d25f906c9.png%401280w_1l_2o_100sh.png&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621494707&t=d5c77830b6072ee07639db4bb2bb4103",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e2d558417e53a8012060c8cbbebf.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621494707&t=c1b40b2e4d01d13ce0dd8f0fd2c5fbd6",*/
    ];
    
    
    NSMutableArray *tmps = @[].mutableCopy;
    for (int i=0; i<imgs.count; i++) {
        ZXBannerModel *goods = [[ZXBannerModel alloc] init];
        goods.cover = imgs[i];
        [tmps addObject:goods];
    }

    ZXHomeBannerModel *bannerModel = [[ZXHomeBannerModel alloc] init];
    bannerModel.type = IsValidString(type) ? type : @"moneyFlower";
    bannerModel.list = tmps.copy;
    
    return bannerModel;
}


@end
