//
//  ZXGoodsModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXGoodsModel.h"

@implementation ZXGoodsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{
        @"showAmount":@[@"showAmount",@"totalPrice"],
    };
}

#pragma mark - mock -

- (NSArray *)mockItems{
    
    NSArray *imgs = @[
    
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fm.360buyimg.com%2Fmobilecms%2Fs750x750_jfs%2Ft17791%2F347%2F1064370232%2F210474%2Fcb300c7b%2F5ab85845na531ffba.jpg%21q80.jpg&refer=http%3A%2F%2Fm.360buyimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpegxxxx",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcbu01.alicdn.com%2Fimg%2Fibank%2F2013%2F865%2F548%2F947845568_726400258.jpg&refer=http%3A%2F%2Fcbu01.alicdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg1.100ye.com%2Fimg2%2F4%2F1386%2F671%2F11079671%2Fmsgpic%2F96459495ba11e0b0c77df0871aad8f08.jpg&refer=http%3A%2F%2Fimg1.100ye.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621049642&t=39c262f3d2c0d394ac0293cb507b5db1",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg006.hc360.cn%2Fk1%2FM00%2FC9%2F54%2FwKhQwFk7W5GEFefCAAAAAEwDrJc715.jpg&refer=http%3A%2F%2Fimg006.hc360.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621049746&t=94069bcff9817441938062babec8745e",
        @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.51yuansu.com%2Fpic3%2Fcover%2F02%2F15%2F95%2F59aeda12a3da1_610.jpg&refer=http%3A%2F%2Fpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1621049746&t=e92a713ecce20d58329b9d0680610855",
    ];
    
    
    if (!_mockItems) {
        NSMutableArray *tmps = @[].mutableCopy;
        for (int i=0; i<imgs.count; i++) {
            ZXGoodsModel *goods = [[ZXGoodsModel alloc] init];
            goods.showMages = imgs[i];
            goods.commodityName = [NSString stringWithFormat:@"国外都在用ins爆款限量款网红第%d版",i];
            goods.showAmount = [NSString stringWithFormat:@"￥%d.5%d0",i,i];
            [tmps addObject:goods];
        }
        
        _mockItems = tmps.copy;
    }
    
    return _mockItems;
}
@end
