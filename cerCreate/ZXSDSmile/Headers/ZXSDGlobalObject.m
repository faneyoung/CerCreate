//
//  ZXSDGlobalObject.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDGlobalObject.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation ZXSDGlobalObject

+ (instancetype)sharedGlobal
{
    static ZXSDGlobalObject *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZXSDGlobalObject new];
        instance.operatorName = @"";
        instance.networkState = @"";
    });
    
    return instance;
}

// 监控网络状态
- (void)startNetworkMonitoring
{
    self.operatorName = [self getOperatorInfomation];
    
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                {
                    ZGLog(@"未知网络");
                    self.networkState = @"未知网络";
                    break;
                }
            case AFNetworkReachabilityStatusNotReachable:
                {
                    ZGLog(@"无网络");
                    self.networkState = @"无网络";
                    break;
                }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                ZGLog(@"WiFi");
                self.networkState = @"WIFI";
                break;
            }
                
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                ZGLog(@"流量");
                NSString *type = [self getWWANType];
                self.networkState = type;
                
                break;
            }
                
                
            default:
                break;
        }
    }];

    [reachability startMonitoring];
}

- (NSString *)getWWANType
{
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    NSString *networkType = @"";
    NSArray *network2G = @[CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x];
    NSArray *network3G = @[CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD];
    NSArray *network4G = @[CTRadioAccessTechnologyLTE];
    
    NSString *currentStatus = CTRadioAccessTechnologyGPRS;
    
    if (@available(iOS 12.0, *)){
       NSDictionary *service =   info.serviceCurrentRadioAccessTechnology;
        currentStatus = [service.allValues firstObject];
        
    } else {
        currentStatus = info.currentRadioAccessTechnology;
    }
    
    if ([network2G containsObject:currentStatus]) {
        networkType = @"2G";
    } else if ([network3G containsObject:currentStatus]) {
        networkType = @"3G";
    } else if ([network4G containsObject:currentStatus]){
        networkType = @"4G";
    } else {
        networkType = @"未知网络";
    }
    
    return networkType;
}

// 获取运营商信息
- (NSString *)getOperatorInfomation
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = nil;
    
    if (@available(iOS 12.0, *)){
        for (CTCarrier * item in info.serviceSubscriberCellularProviders.allValues) {
            if (CHECK_VALID_STRING(item.carrierName)) {
                carrier = item;
                break;
            }
        }
    } else {
        carrier = [info subscriberCellularProvider];
    }
    
    if (carrier == nil) {
        return @"不能识别";
    }
    
    NSString *name = carrier.carrierName;
    if (!CHECK_VALID_STRING(name)) {
        name = @"不能识别";
    }
    
    return name;

}

@end
