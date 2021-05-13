//
//  ZXSDCityModel.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDCityModel : ZXSDBaseModel

__string(name)

@property (nonatomic, strong) NSMutableArray *cityArray;

+ (NSArray*)modelsArrayWithData:(NSDictionary*)json;

+ (NSArray*)jobArrayWithWithData:(NSDictionary*)json;

@end

NS_ASSUME_NONNULL_END
