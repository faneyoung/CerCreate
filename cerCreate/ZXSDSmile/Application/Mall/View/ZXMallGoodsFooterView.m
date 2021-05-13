//
//  ZXMallGoodsFooterView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/14.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallGoodsFooterView.h"
#import "UIButton+ExpandClickArea.h"

@implementation ZXMallGoodsFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kThemeColorBg;
        
        UIImageView *logoImgView = [[UIImageView alloc] initWithImage:UIImageNamed(@"icon_mall_logo")];
        [self addSubview:logoImgView];
        [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(40);
            make.centerX.offset(0);
            make.height.mas_equalTo(16);
        }];
        
        UILabel *desLab = [UILabel labelWithText:@"预支不求人，我有薪朋友" textColor:TextColorSubTitle font:FONT_PINGFANG_X(13)];
        [self addSubview:desLab];
        [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logoImgView.mas_bottom).inset(12);
            make.centerX.offset(0);
            make.height.mas_equalTo(14);
        }];
        
        UIButton *serviceBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(13) title:@"我的客服" textColor:TextColorSubTitle];
        serviceBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -30, -10, -30);
        [self addSubview:serviceBtn];
        [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(desLab.mas_bottom).inset(12);
            make.centerX.offset(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(28);
        }];
        ViewBorderRadius(serviceBtn, 14, 1, TextColorPlacehold);
        
        [serviceBtn bk_addEventHandler:^(id sender) {
            NSString *url = WebPageUrlFormatter(kPath_myService, nil);
            [URLRouter routerUrlWithPath:url extra:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        

        
    }
    return self;
}

@end
