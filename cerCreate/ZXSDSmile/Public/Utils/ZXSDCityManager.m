//
//  ZXSDCityManager.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCityManager.h"

@implementation ZXSDCityManager

+ (id)sharedManager {
    static ZXSDCityManager *cm = nil;
    @synchronized (self) {
        if (!cm) {
            cm = [ZXSDCityManager new];
        }
    }
    return cm;
}

- (NSMutableArray *)parsingDataWithPath:(NSString *)path {
    NSMutableArray *returnList = [NSMutableArray  new];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSArray *dataArray = [obj objectForKey:@"data"];
        for (NSDictionary *dict in dataArray) {
            ZXSDCityModel *model = [ZXSDCityModel new];
            model.name = [dict objectForKey:@"name"];
            NSArray *cities = [dict objectForKey:@"cities"];
            for (NSString *city in cities) {
                [model.cityArray addObject:city];
            }
            [returnList addObject:model];
        }
    }
    return returnList;
}

@end
