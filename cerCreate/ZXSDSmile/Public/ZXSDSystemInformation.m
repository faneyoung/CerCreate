//
//  ZXSDSystemInformation.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/5.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDSystemInformation.h"
#import "sys/utsname.h"
#import <AdSupport/ASIdentifierManager.h> //idfa

@implementation ZXSDSystemInformation

//获取设备型号
+ (NSString*)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"]) {
        return @"iPhone 1G";
    }
    if ([deviceString isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G";
    }
    if ([deviceString isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS";
    }
    if ([deviceString isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4";
    }
    if ([deviceString isEqualToString:@"iPhone3,2"]) {
        return @"Verizon iPhone 4";
    }
    if ([deviceString isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    }
    if ([deviceString isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    }
    if ([deviceString isEqualToString:@"iPhone5,3"]) {
        return @"iPhone 5C";
    }
    if ([deviceString isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5C";
    }
    if ([deviceString isEqualToString:@"iPhone6,1"]) {
        return @"iPhone 5S";
    }
    if ([deviceString isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5S";
    }
    if ([deviceString isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    }
    if ([deviceString isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    }
    if ([deviceString isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus";
    }
    if ([deviceString isEqualToString:@"iPhone8,4"]) {
        return @"iPhone 5 SE";
    }
    if ([deviceString isEqualToString:@"iPhone9,1"]) {
        return @"iPhone 7";
    }
    if ([deviceString isEqualToString:@"iPhone9,2"]) {
        return @"iPhone 7 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,1"]) {
        return @"iPhone 8";
    }
    if ([deviceString isEqualToString:@"iPhone10,2"]) {
        return @"iPhone 8 Plus";
    }
    if ([deviceString isEqualToString:@"iPhone10,3"]) {
        return @"iPhone X";
    }
    if ([deviceString isEqualToString:@"iPhone11,2"]) {
        return @"iPhone XS";
    }
    if ([deviceString isEqualToString:@"iPhone11,4"]) {
        return @"iPhone XS Max";
    }
    if ([deviceString isEqualToString:@"iPhone11,6"]) {
        return @"iPhone XS Max";
    }
    if ([deviceString isEqualToString:@"iPhone11,8"]) {
        return @"iPhone XR";
    }
    if ([deviceString isEqualToString:@"iPhone12,1"]) {
        return @"iPhone 11";
    }
    if ([deviceString isEqualToString:@"iPhone12,3"]) {
        return @"iPhone 11 Pro";
    }
    if ([deviceString isEqualToString:@"iPhone12,5"]) {
        return @"iPhone 11 Pro Max";
    }
    if ([deviceString isEqualToString:@"iPhone12,8"]) {
        return @"iPhone SE";
    }
    return deviceString;
}

+ (NSString *)idfv {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)idfa {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

+ (NSString *)screen {
    return [NSString stringWithFormat:@"%.0f*%.0f",[[UIScreen mainScreen] currentMode].size.width,[[UIScreen mainScreen] currentMode].size.height];
}

+ (NSString *)systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}


@end
