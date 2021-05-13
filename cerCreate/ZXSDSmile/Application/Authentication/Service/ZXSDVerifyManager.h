//
//  ZXSDVerifyManager.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXSDVerifyActionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDVerifyManager : NSObject

@property (nonatomic, assign) NSInteger totalActions;
@property (nonatomic, assign) NSInteger currentStep;

+ (ZXSDVerifyActionModel *)IDCardVerifyAction;
+ (ZXSDVerifyActionModel *)livingDetectionAction;
+ (ZXSDVerifyActionModel *)bankCardBindingAction;
+ (ZXSDVerifyActionModel *)employerBindingAction;

@end

NS_ASSUME_NONNULL_END
