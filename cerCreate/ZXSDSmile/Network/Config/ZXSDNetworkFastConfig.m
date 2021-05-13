//
//  ZXSDNetworkFastConfig.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/31.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDNetworkFastConfig.h"
#import "ZXSDResponseHandler.h"

#if TEST
//NSString *const MAIN_URL = @"http://sc-portal.t.cashbus.com";
//NSString *const DOMAINURL = @"sc-portal.t.cashbus.com";
NSString *const MAIN_URL = @"http://sc-portal.fat.smilecard.cn";
NSString *const DOMAINURL = @"sc-portal.fat.smilecard.cn";

NSString *const H5_URL = @"http://sc-front.t.cashbus.com";
NSString *const H5_WEB = @"http://sc-h5.t.cashbus.com";




NSString *const MARS_HMAC_KEY = @"testAppKeyId5";
NSString *const MARS_HMAC_SEND_MS = @"120";
NSString *const MARS_APP_SECRET = @"testAppSecret5";


//一键验证登录SDK的Key和Secret
//NSString *const YJYZSDKAPPKEY = @"5b279456da98d";
//NSString *const YJYZSDKAPPSECRET = @"e1b687b47eebee6cc331bb3aa795fe70";

NSString *const YJYZSDKAPPKEY = @"5ac4578be6638";
NSString *const YJYZSDKAPPSECRET = @"14bcc00f335623080640a5a2eb244d26";

#elif UAT
NSString *const MAIN_URL = @"http://sc-portal-uat.t.cashbus.com";
NSString *const DOMAINURL = @"sc-portal-uat.t.cashbus.com";
NSString *const H5_URL = @"http://sc-front-uat.t.cashbus.com";
NSString *const H5_WEB = @"http://sc-h5-uat.t.cashbus.com";

NSString *const MARS_HMAC_KEY = @"testAppKeyId5";
NSString *const MARS_HMAC_SEND_MS = @"120";
NSString *const MARS_APP_SECRET = @"testAppSecret5";

//一键验证登录SDK的Key和Secret
NSString *const YJYZSDKAPPKEY = @"5ac4578be6638";
NSString *const YJYZSDKAPPSECRET = @"14bcc00f335623080640a5a2eb244d26";

#elif RELEASE
NSString *const MAIN_URL = @"https://sc-portal.smilecard.cn";
NSString *const DOMAINURL = @"sc-portal.smilecard.cn";
NSString *const H5_URL = @"https://sc-front.smilecard.cn";
NSString *const H5_WEB = @"https://sc-h5.smilecard.cn";

NSString *const MARS_HMAC_KEY = @"prodSMIL";
NSString *const MARS_HMAC_SEND_MS = @"120";
NSString *const MARS_APP_SECRET = @"Odv8jGan6F!CXYN0AW%RO47u%8CbpH3";

//一键验证登录SDK的Key和Secret
NSString *const YJYZSDKAPPKEY = @"5ac4578be6638";
NSString *const YJYZSDKAPPSECRET = @"14bcc00f335623080640a5a2eb244d26";

#endif





@implementation ZXSDNetworkFastConfig

- (instancetype)init
{
    if (self = [super init]) {
        self.needSign = NO;
        //self.signatureMaker = [EPNetworkSignatureService sharedSignatureService];
        self.responseHandler = [ZXSDResponseHandler sharedResponseHandler];
    }
    return self;
}

- (NSString *)baseURL
{
    return MAIN_URL;
}

- (NSString *)apiBasePath
{
    return @"";
}



@end
