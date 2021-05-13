//
//  ZXSDVerifyManager.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDVerifyManager.h"

@implementation ZXSDVerifyManager

+ (instancetype)sharedManager
{
    static ZXSDVerifyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ZXSDVerifyManager new];
    });
    return manager;
}

+ (ZXSDVerifyActionModel *)IDCardVerifyAction
{
    ZXSDVerifyActionModel *model = [ZXSDVerifyActionModel new];
    model.name = @"上传身份证";
    model.totalActions = [[ZXSDVerifyManager sharedManager] totalActions];
    model.currentStep = 1;
    return model;
}

+ (ZXSDVerifyActionModel *)livingDetectionAction
{
    ZXSDVerifyActionModel *model = [ZXSDVerifyActionModel new];
    model.name = @"人脸识别";
    model.totalActions = [[ZXSDVerifyManager sharedManager] totalActions];
    model.currentStep = 2;
    return model;
}

+ (ZXSDVerifyActionModel *)bankCardBindingAction
{
    ZXSDVerifyActionModel *model = [ZXSDVerifyActionModel new];
    model.name = @"绑定工资卡";
    model.totalActions = [[ZXSDVerifyManager sharedManager] totalActions];
    model.currentStep = 3;
    return model;
}

+ (ZXSDVerifyActionModel *)employerBindingAction
{
    ZXSDVerifyActionModel *model = [ZXSDVerifyActionModel new];
    model.name = @"填写雇主信息";
    model.totalActions = [[ZXSDVerifyManager sharedManager] totalActions];
    model.currentStep = 2;
    return model;
}

- (NSInteger)totalActions
{
    if ([ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery) {
        return 2;
    }
    return 2;
}

- (NSInteger)currentStep
{
    return 1;
}

@end
