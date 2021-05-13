//
//  ZXSDBaseModel.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseModel.h"

@implementation ZXSDBaseModel
+ (instancetype)modelWithJSON:(id)json{
    if (!json) {
        return nil;
    }
    
    return [self yy_modelWithJSON:json];
}

+ (instancetype)modelWithDictionary:(id)dic{
    return [self modelWithJSON:dic];
}

+ (NSMutableArray *)parsingDataWithJson:(NSData *)data {
    return nil;
}

+ (NSArray *)parserDatasWithObj:(id)obj {
    if(!IsValidArray(obj)){
        return nil;
    }
    return [NSArray yy_modelArrayWithClass:self.class json:obj];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSAssert(NO, @"Undefined Key");
}

@end
