//
//  ZXBaseModel.h
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+objectForKey.h"
#import "NSMutableDictionary+SafeSetter.h"
#import <NSObject+YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBaseModel : NSObject <NSCopying, NSCoding, YYModel>

+ (instancetype)instanceWithData:(id)data;
+ (instancetype)instanceWithDictionary:(NSDictionary*)dic;

+ (NSArray*)modelsWithData:(id)data;

+ (NSArray*)mockItems;

@end

NS_ASSUME_NONNULL_END
