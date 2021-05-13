//
//  ZXSDCityManager.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXSDCityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDCityManager : NSObject

+ (id)sharedManager;

- (NSMutableArray *)parsingDataWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
