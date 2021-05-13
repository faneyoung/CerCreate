//
//  ZXSDLivingDetectionController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LivingDetectionType) {
    LivingDetectionTypeDefault,
    LivingDetectionTypePhoneUpdate,///换绑手机号的人脸认证
    LivingDetectionTypeChangePhone,///匿名换绑手机号的人脸认证
};

// 人脸检测&活体识别
@interface ZXSDLivingDetectionController : ZXSDBaseViewController

@property (nonatomic, assign) LivingDetectionType detectType;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userRefId;


@end

NS_ASSUME_NONNULL_END
