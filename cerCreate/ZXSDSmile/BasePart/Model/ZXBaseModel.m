//
//  ZXBaseModel.m
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXBaseModel.h"
#import <NSObject+YYModel.h>

@implementation ZXBaseModel

+ (instancetype)instanceWithData:(id)data{
    
    if (IsValidDictionary(data)) {
        return [[self class] instanceWithDictionary:data];
    }
    else if(IsValidString(data)){
        ZXBaseModel *model = [[self class] yy_modelWithJSON:data];
        return model;
    }
    
    return nil;
}


+ (instancetype)instanceWithDictionary:(NSDictionary *)dic{
    if (!IsValidDictionary(dic)) {
        return nil;
    }
    ZXBaseModel *model = [[self class] yy_modelWithJSON:dic];
    return model;
}

+ (NSArray*)modelsWithData:(id)data{
    if (!IsValidArray(data)) {
        return nil;
    }
    
    return [NSArray yy_modelArrayWithClass:[self class] json:data];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init]; return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}

- (NSUInteger)hash
{
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object
{
    return [self yy_modelIsEqual:object];
}

- (NSString *)description
{
    return [self yy_modelDescription];
}

#pragma mark - help  -
+ (NSArray*)mockItems{
    return nil;
}
@end
