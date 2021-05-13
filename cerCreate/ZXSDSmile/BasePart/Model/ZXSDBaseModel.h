//
//  ZXSDBaseModel.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/3.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
#import <NSArray+YYAdd.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDBaseModel : NSObject
+ (instancetype)modelWithJSON:(id)json;
+ (instancetype)modelWithDictionary:(id)dic;

+ (NSMutableArray *)parsingDataWithJson:(NSData *)data;
+ (NSArray *)parserDatasWithObj:(id)obj;

@end

NS_ASSUME_NONNULL_END
