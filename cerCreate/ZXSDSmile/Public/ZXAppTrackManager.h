//
//  ZXAppTrackManager.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/9.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXTrackHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXAppTrackManager : NSObject

+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId extra:(NSDictionary * __nullable)extra;

+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;


@end


static inline void TrackEvent(NSString *event){
    [ZXAppTrackManager event:event];
}

static inline void TrackEventExtra(NSString *event,NSDictionary *params){
    [ZXAppTrackManager event:event extra:params];
}


NS_ASSUME_NONNULL_END
