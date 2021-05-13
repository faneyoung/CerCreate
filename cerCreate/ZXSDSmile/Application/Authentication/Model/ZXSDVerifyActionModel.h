//
//  ZXSDVerifyActionModel.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDVerifyActionModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger totalActions;

@end

NS_ASSUME_NONNULL_END
