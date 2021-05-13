//
//  ZXSDBankCardModel.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/24.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBankCardModel.h"

static inline NSDictionary* BankCardConfigsMap()
{
    return @{
              // 黄色
              @"0303": @{
                @"color":@(0xFFA800),
                @"icon":@"bank_0303",
                @"name":@"光大银行"
              },
              @"0318": @{
                @"color":@(0xFFA800),
                @"icon":@"bank_0318",
                @"name":@"平安银行"
              },
              
              // 红色
              @"0403": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0403",
                @"name":@"北京银行"
              },
              
              @"0306": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0306",
                @"name":@"广发银行"
              },
              
              @"0102": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0102",
                @"name":@"工商银行"
              },
              
              @"0304": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0304",
                @"name":@"华夏银行"
              },
              
              @"0308": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0308",
                @"name":@"招商银行"
              },
              
              @"0104": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0104",
                @"name":@"中国银行"
              },
              
              @"0302": @{
                @"color":@(0xF36353),
                @"icon":@"bank_0302",
                @"name":@"中信银行"
              },
              
              //蓝色
              @"0105": @{
                @"color":@(0x5886E2),
                @"icon":@"bank_0105",
                @"name":@"建设银行"
              },
              
              @"0301": @{
                @"color":@(0x5886E2),
                @"icon":@"bank_0301",
                @"name":@"交通银行"
              },
              
              @"0310": @{
                @"color":@(0x5886E2),
                @"icon":@"bank_0310",
                @"name":@"浦发银行"
              },
              
              @"0309": @{
                @"color":@(0x5886E2),
                @"icon":@"bank_0309",
                @"name":@"兴业银行"
              },
              
              // 灰色
              @"0103": @{
                @"color":@(0x626F8A),
                @"icon":@"bank_0103",
                @"name":@"农业银行"
              },
              
              @"0305": @{
                @"color":@(0x626F8A),
                @"icon":@"bank_0305",
                @"name":@"民生银行"
              },
              
              @"0100": @{
                @"color":@(0x626F8A),
                @"icon":@"bank_0100",
                @"name":@"中国邮政储蓄银行"
              }
              
             };
}

@implementation ZXSDBankCardModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"debitCardNumber" :@"number",
        @"phoneNumber" :@"reservePhone",
        @"bankLogoUrl" : @"bankIcon"
    };
}

@end


@implementation ZXSDBankCardItem

- (NSDictionary *)UIConfig
{
    NSDictionary *config = [BankCardConfigsMap() objectForKey:self.bankCode];
    if (!config) {
        config = @{
          @"color":@(0x626F8A),
          @"icon":@""
        };
    }
    return config;
}

@end
