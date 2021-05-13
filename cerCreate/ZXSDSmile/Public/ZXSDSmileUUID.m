//
//  ZXSDSmileUUID.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDSmileUUID.h"
#import "SAMKeychain.h"

static NSString *const UUIDFORDEVICEKEY = @"ZXSDSmileUUIDForDevice";
static NSString *const ZXSD_SMILE_PASSWORDFORSERVICE = @"ZXSDSmilePasswordForService";

@implementation ZXSDSmileUUID

+ (id)sharedInsance {
    static ZXSDSmileUUID *_uuid = nil;
    if (!_uuid) {
        _uuid = [[ZXSDSmileUUID alloc] init];
    }
    return _uuid;
}

- (NSString *)getUUID {
    NSString *oldUUID = [SAMKeychain passwordForService:ZXSD_SMILE_PASSWORDFORSERVICE account:UUIDFORDEVICEKEY];
    NSString *result;
    if (oldUUID) {
        result = oldUUID;
    } else {
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        [SAMKeychain setPassword:result forService:ZXSD_SMILE_PASSWORDFORSERVICE account:UUIDFORDEVICEKEY];
        return result;
    }
    return result;
}

@end
