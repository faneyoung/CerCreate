//
//  ZXScoreUploadModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScoreUploadModel.h"

@implementation ZXScoreStepItemModel

+ (instancetype) itemWithType:(NSString*)type step:(int)step{
    ZXScoreStepItemModel *item = [[ZXScoreStepItemModel alloc] init];
    if ([type isEqualToString:@"referScoreSesame"]) {
        if (step == 0) {
            item.img = UIImageNamed(@"icon_task_score_aliLogo");
            item.title = @"1. 请登录您的支付宝";
            item.des = @"截取您的芝麻信用分等图片信息";

        }
        else if(step == 1){
            item.img = UIImageNamed(@"icon_task_score_aliUpArrow");
            item.title = @"2. 上传您的截图";
            item.des = @"请勿裁剪涂抹，会影响您的审批结果";
        }
    }
    else if ([type isEqualToString:@"referScoreWechat"]){
        if (step == 0) {
            item.img = UIImageNamed(@"icon_task_score_wxLogo");
            item.title = @"1. 请登录您的微信";
            item.des = @"截取您的微信支付分等图片信息";

        }
        else if(step == 1){
            item.img = UIImageNamed(@"icon_task_score_wxUpArrow");
            item.title = @"2. 上传您的截图";
            item.des = @"请勿裁剪涂抹，会影响您的审批结果";
        }

    }
    
    return item;
}

@end

@implementation ZXScoreUploadModel

- (BOOL)isAliScore{
    return [self.type isEqualToString:@"referScoreSesame"];
}

- (BOOL)isWxScore{
    return [self.type isEqualToString:@"referScoreWechat"];
}

- (UIImage *)cameraImg{
    
    if (!_cameraImg) {
        _cameraImg = UIImageNamed(@"icon_score_camera_ali");
        if ([self isWxScore]) {
            _cameraImg = UIImageNamed(@"icon_score_camera_wx");
        }
    }

    return _cameraImg;
}

- (UIImage *)authImg{
    if (!_authImg) {
        _authImg = UIImageNamed(@"icon_score_camera_auth_ali");
        if([self isWxScore]){
            _authImg = UIImageNamed(@"icon_score_camera_auth_wx");
        }
    }
    return _authImg;
}

- (NSString *)title{
    _scoreTitle = @"芝麻信用分";
    if ([self isWxScore]) {
        _scoreTitle = @"微信支付分";
    }
    return _scoreTitle;
}

- (NSString *)scoreTitle{
    _scoreTitle = @"上传芝麻信用分的页面";
    if ([self isWxScore]) {
        _scoreTitle = @"上传微信支付分的页面";
    }
    return _scoreTitle;
}

- (NSString *)uploadDesTitle{
    _uploadDesTitle = @"芝麻信用分截图示例";
    if ([self isWxScore]) {
        _uploadDesTitle = @"微信支付分截图示例";
    }
    return _uploadDesTitle;
}

- (NSString *)uploadDesAuthTitle{
    _uploadDesTitle = @"账号与安全截图示例";
    if ([self isWxScore]) {
        _uploadDesTitle = @"微信支付分截图示例";
    }
    return _uploadDesTitle;

}

- (NSString *)uploadDesShotScreen{
    _uploadDesTitle = @"icon_uplaodScore_des_ali";
    if ([self isWxScore]) {
        _uploadDesTitle = @"icon_uplaodScore_des_wx";
    }
    return _uploadDesTitle;

}

- (NSString *)uploadDesShotScreenAuth{
    _uploadDesShotScreenAuth = @"icon_uplaodScore_authDes_ali";
    if ([self isWxScore]) {
        _uploadDesShotScreenAuth = @"icon_uplaodScore_authDes_wx";
    }
    return _uploadDesShotScreenAuth;

}

- (NSArray *)uploadDesItems{
    NSArray *tmps = @[];
    tmps = @[
        @"1.打开\"支付宝\"",
        @"2.点击\"我的\"",
        @"3.点击\"芝麻信用\""
    ];
    
    if ([self isWxScore]) {
        tmps = @[
            @"1.打开\"微信\"，点击\"我\"",
            @"2.进入\"支付\"，点击\"钱包\"",
            @"3.进入\"支付分\"",
        ];
    }
    
    
    
    return tmps;
}

- (NSArray *)uploadDesAuthItems{
    NSArray *tmps = @[];
    tmps = @[
        @"打开\n支付宝",
        @"点击\n我的",
        @"点击\n设置",
        @"进入\n账号与安全",
    ];
    
    if ([self isWxScore]) {
        tmps = @[
            @"打开\n微信",
            @"点击\n我",
            @"进入\n支付",
            @"点击\n右上角",
            @"进入\n实名认证",
        ];
    }
    
    
    return tmps;

}

@end
