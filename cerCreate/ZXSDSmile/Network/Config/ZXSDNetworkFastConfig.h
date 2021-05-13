//
//  ZXSDNetworkFastConfig.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/31.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "EPNetworkConfig.h"

#define USER_AGENT @"com.zxsd.smile.ios.v"

extern NSString *const MAIN_URL;
extern NSString *const DOMAINURL;
extern NSString *const H5_URL;
extern NSString *const H5_WEB;

extern NSString *const MARS_HMAC_KEY;
extern NSString *const MARS_HMAC_SEND_MS;
extern NSString *const MARS_APP_SECRET;

extern NSString *const YJYZSDKAPPKEY;
extern NSString *const YJYZSDKAPPSECRET;

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDNetworkFastConfig : EPNetworkConfig

@end

NS_ASSUME_NONNULL_END
