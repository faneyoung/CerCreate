//
//  ZXAppTrackManager.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXAppTrackManager.h"
#import <UMCommon/MobClick.h>
#import "ZXSDCurrentUser.h"

@implementation ZXAppTrackManager

+ (void)event:(NSString *)eventId{
    [ZXAppTrackManager event:eventId extra:nil];
}

+ (void)event:(NSString *)eventId extra:(NSDictionary * __nullable)extra{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithCapacity:1];
    [attrs setSafeValue:[ZXSDCurrentUser currentUser].phone forKey:@"userId"];
    if (IsValidDictionary(extra)) {
        [attrs addEntriesFromDictionary:extra];
    }
    [MobClick event:eventId attributes:attrs.copy];
}

+ (void)beginLogPageView:(NSString *)pageName{
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName{
    [MobClick endLogPageView:pageName];
}

@end
