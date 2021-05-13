//
//  ZXLocationManager.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface ZXLocationManager () <CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *locationManager;

/// 定位成功的回调block
@property (nonatomic, copy) void (^successBlock)(NSDictionary *);
/// 编码成功的回调block
@property (nonatomic, copy) void (^geocodeBlock)(NSArray *geocodeArray);
/// 定位失败的回调block
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

@end

@implementation ZXLocationManager

+ (instancetype)sharedManger{
    static ZXLocationManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ZXLocationManager alloc] init];
    });
    
    return manager;
}


- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0f;
    }
    return _locationManager;
}

- (void)requestLocationAuth{
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)startLocationWithSuccessBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *error))failureBlock{
    
    [self startLocationWithSuccessBlock:successBlock failureBlock:failureBlock geocoderBlock:nil];
    
}

- (void)startLocationWithSuccessBlock:(void (^)(NSDictionary *))successBlock failureBlock:(void (^)(NSError *error))failureBlock geocoderBlock:(void (^)(NSArray *geocoderArray))geocoderBlock {
    
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    self.geocodeBlock = geocoderBlock;
    
    [self getLocationPermission];
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    
    //通常只取数组第0个元素
    CLLocation *location = locations.lastObject;
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    if (latitude > 0 && longitude > 0) {
        
        [manager stopUpdatingLocation];
        
        _locationDic = @{@"latitude":[NSNumber numberWithDouble:latitude],@"longitude":[NSNumber numberWithDouble:longitude]};
        [self checkLocationInfomation];
    }

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startLocationWithSuccessBlock:self.successBlock failureBlock:self.failureBlock];
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self.locationManager stopUpdatingLocation];
    
    CLAuthorizationStatus staus = [CLLocationManager authorizationStatus];
    if (staus == kCLAuthorizationStatusDenied) {
        NSLog(@"----------");

        
        return;
    }

    NSLog(@"定位失败, 错误: %@",error);
    switch([error code]) {
        case kCLErrorDenied: { // 用户禁止了定位权限
            
        } break;
        default: break;
    }

    if (_failureBlock) {
        _failureBlock(error);
        _failureBlock = nil;
    }
}

#pragma mark - help methods -

- (void)showAlert{
    
    NSString *msg = [NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】-【隐私】-【定位服务】中打开，并允许%@使用定位服务", APPName];
    [AppUtility alertViewWithTitle:@"温馨提示" content:msg cancelTitle:@"取消" cancel:^{
        
    } confirmTitle:@"前往设置" confirm:^{
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
            [[UIApplication sharedApplication] openURL:settingsUrl];
        }

    }];

}


- (void)showLocationAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *nextAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
            [[UIApplication sharedApplication] openURL:settingsUrl];
        }
    }];
    [alertController addAction:nextAction];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    
    [[EasyShowUtils easyShowViewTopViewController] presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - Location
- (void)getLocationPermission {

    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if(![CLLocationManager locationServicesEnabled] ||
       status < kCLAuthorizationStatusDenied) {//尚未授权
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        if (self.failureBlock) {
            self.failureBlock([NSError errorWithDomain:@"kLocError" code:-1 userInfo:nil]);
            self.failureBlock = nil;
        }

        return;
    }

    if (status == kCLAuthorizationStatusDenied) {
        
        [self showLocationAlertWithMessage:@"请在设置->隐私->定位服务打开定位"];
        
        if (self.failureBlock) {
            self.failureBlock([NSError errorWithDomain:@"kLocError" code:-1 userInfo:nil]);
            self.failureBlock = nil;
        }
        
        return;
    }
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)checkLocationInfomation {
    
    if([self.locationDic stringObjectForKey:@"latitude"].doubleValue == 0 ||
       [self.locationDic stringObjectForKey:@"longitude"].doubleValue == 0) {//定位中&失败重复点击控制
        if ([ZXSDUserDefaultHelper readValueForKey:kActivityListLocationDateKey]) {
            
            NSDate *lastDate = (NSDate *)[ZXSDUserDefaultHelper readValueForKey:kActivityListLocationDateKey];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval interval = [currentDate timeIntervalSinceDate:lastDate];
            if (interval < 5) {
                ToastShow(@"正在获取位置信息请稍后再试");
            } else {
                [ZXSDUserDefaultHelper storeValueIntoUserDefault:currentDate forKey:kActivityListLocationDateKey];
                [self refreshLocationInfomation];
            }
        } else {
            NSDate *lastDate = [NSDate date];
            [ZXSDUserDefaultHelper storeValueIntoUserDefault:lastDate forKey:kActivityListLocationDateKey];
            ToastShow(@"正在获取位置信息请稍后再试");
        }
    } else {
        [self refreshLocationInfomation];
    }
}

- (void)refreshLocationInfomation{
    
    
    if (_successBlock) {
        _successBlock(self.locationDic);
        _successBlock = nil;
    }
    
//    if (_geocodeBlock) {
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[self.locationDic doubleValueForKey:@"latitude"] longitude:[self.locationDic doubleValueForKey:@"longitude"]];
//        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
//            self->_geocodeBlock(array);
//        }];
//    }


}


@end
