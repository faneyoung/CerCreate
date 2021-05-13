//
//  ZXSDCityModel.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCityModel.h"
#import <NSObject+YYModel.h>

#import "NSDictionary+objectForKey.h"

@implementation ZXSDCityModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSArray*)modelsArrayWithData:(NSDictionary*)json{
    if (!IsValidDictionary(json)) {
        return nil;
    }
    
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}

+ (NSArray*)jobArrayWithWithData:(NSDictionary*)json{
    if (!IsValidDictionary(json)) {
        return nil;
    }
    
    NSArray *jobTitles = [json arrayObjectForKey:@"jobCategory"];
    NSDictionary *jobDic = [json dictionaryObjectForKey:@"job"];
    
    __block NSMutableArray *jobs = [NSMutableArray arrayWithCapacity:jobTitles.count];
    [jobTitles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZXSDCityModel *job = [[ZXSDCityModel alloc] init];
        job.name = obj;
        job.cityArray = [jobDic arrayObjectForKey:obj].mutableCopy;
        [jobs addObject:job];
    }];
    
    return jobs.copy;
}

@end
