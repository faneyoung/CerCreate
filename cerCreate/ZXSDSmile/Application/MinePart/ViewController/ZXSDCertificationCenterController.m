//
//  ZXSDCertificationCenterController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCertificationCenterController.h"
#import "ZXSDCertificationCenterCell.h"
#import "ZXSDImprovePersonalInfoController.h"
#import "ZXSDFrequentContactsController.h"
#import "ZXSDUploadBankDetailsController.h"
#import "ZXSDUploadWechatDetailsController.h"
#import "ZXSDUploadDetailsResultController.h"
#import <CoreLocation/CoreLocation.h>

static const NSString *CERTIFICATION_CENTER_URL = @"/rest/userInfo/getTaskCenter";
static const NSString *UPLOAD_LOCATION_URL = @"/rest/certificate/geographic";
static NSString *const LAST_UPLOAD_LOCATION_DATE = @"lastUploadLocationDate";

@interface ZXSDCertificationCenterController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate> {
    UITableView *_certTableView;
    UIView *_headerView;
    UIView *_promptView;
    
    NSMutableArray *_channelNameArray;
    NSMutableArray *_channelDicArray;
    NSMutableArray *_channelModelArray;
    
    CLLocationManager *_locationManager;
    NSDictionary *_locationDic;
    BOOL _isLocationClose;
}

@end

@implementation ZXSDCertificationCenterController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务中心";
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TrackEvent(ktaskCenterList);
    
    [self refreshDataConfigure];
}

- (void)prepareDataConfigure {
    _locationDic = @{@"latitude":[NSNumber numberWithDouble:0], @"longitude":[NSNumber numberWithDouble:0]};
    
    _channelNameArray = [[NSMutableArray alloc] init];
    _channelDicArray = [[NSMutableArray alloc] init];
}

- (void)refreshDataConfigure {
    //处理数据
    if (_channelNameArray.count > 0) {
        [_channelNameArray removeAllObjects];
    }
    
    if (_channelDicArray.count > 0) {
        [_channelDicArray removeAllObjects];
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,CERTIFICATION_CENTER_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取任务中心信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        [self->_certTableView.mj_header endRefreshing];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [self->_channelDicArray removeAllObjects];
            [self->_channelNameArray removeAllObjects];
            
            for (NSDictionary *responseDic in responseObject) {
                NSString *channelName = [responseDic objectForKey:@"titleDesc"];
                NSArray *modelsArray = [responseDic objectForKey:@"statusDTOS"];
                if ([channelName isKindOfClass:[NSString class]] && channelName.length > 0) {
                    [self->_channelNameArray addObject:channelName];
                }
                if ([modelsArray isKindOfClass:[NSArray class]] && modelsArray.count > 0) {
                    [self->_channelDicArray addObject:modelsArray];
                }
            }
            
            if (self->_channelDicArray.count > 0) {
                NSMutableArray *listArray = [ZXSDCertificationCenterModel parsingDataWithJson:self->_channelDicArray];
                self->_channelModelArray = [NSMutableArray arrayWithArray:listArray];
            }
            
            [self->_certTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        [self->_certTableView.mj_header endRefreshing];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)addUserInterfaceConfigure {
    _certTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT()) style:UITableViewStylePlain];
    _certTableView.delegate = self;
    _certTableView.dataSource = self;
    _certTableView.showsVerticalScrollIndicator = NO;
    _certTableView.backgroundColor = [UIColor whiteColor];
    _certTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_certTableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 40)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 40)];
    _promptView.backgroundColor = UICOLOR_FROM_HEX(0xFFF4D4);
    [_headerView addSubview:_promptView];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH() - 50, 20)];
    promptLabel.text = @"完善认证，可提升预支额度的通过率";
    promptLabel.textColor = UICOLOR_FROM_HEX(0xC8A028);
    promptLabel.font = FONT_PINGFANG_X(12);
    [_promptView addSubview:promptLabel];
    
    UIButton *promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    promptButton.frame =  CGRectMake(SCREEN_WIDTH() - 45, 5, 30, 30);
    [promptButton setImage:UIIMAGE_FROM_NAME(@"cert_center_close") forState:UIControlStateNormal];
    [promptButton addTarget:self action:@selector(promptButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_promptView addSubview:promptButton];
    
    _certTableView.tableHeaderView = _headerView;
    _certTableView.tableFooterView = [UIView new];
    
    _certTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshDataConfigure];
    }];

    [_certTableView registerClass:[ZXSDCertificationCenterCell class] forCellReuseIdentifier:[ZXSDCertificationCenterCell identifier]];
    //[_certTableView registerNib:[UINib nibWithNibName:@"ZXSDCertificationCenterCell" bundle:nil] forCellReuseIdentifier:@"certificationCenterCell"];
}

- (void)cancelButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)promptButtonClicked {
    [_promptView removeFromSuperview];
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 0);
    [_certTableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _channelModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_channelModelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXSDCertificationCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDCertificationCenterCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_channelModelArray.count != 0) {
        ZXSDCertificationCenterModel *model = _channelModelArray[indexPath.section][indexPath.row];
        [cell setRenderData:model];
        
        if (indexPath.row != [_channelModelArray[indexPath.section] count] - 1) {
            [cell showBottomLine];
        } else {
            [cell hideBottomLine];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZXSDCertificationCenterModel *model = _channelModelArray[indexPath.section][indexPath.row];
    if ([model.certType isEqualToString:@"personInfo"]) {
        TrackEvent(ktask_personalInformation);
        
        ZXSDImprovePersonalInfoController *viewController = [ZXSDImprovePersonalInfoController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.certType isEqualToString:@"contract"]) {
        TrackEvent(kContacts);
        
        ZXSDFrequentContactsController *viewController = [ZXSDFrequentContactsController new];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([model.certType isEqualToString:@"salaryInfo"]) {
        if ([model.certStatus isEqualToString:@"NotDone"] || [model.certStatus isEqualToString:@"Expired"]) {
            ZXSDUploadBankDetailsController *viewController = [ZXSDUploadBankDetailsController new];
            viewController.certType = model.certType;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            ZXSDUploadDetailsResultController *viewController = [ZXSDUploadDetailsResultController new];
            viewController.certType = model.certType;
            viewController.certStatus = model.certStatus;
            viewController.failureDesc = model.certContent;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if ([model.certType isEqualToString:@"consumeInfo"]) {
        if ([model.certStatus isEqualToString:@"NotDone"] || [model.certStatus isEqualToString:@"Expired"]) {
            ZXSDUploadWechatDetailsController *viewController = [ZXSDUploadWechatDetailsController new];
            viewController.certType = model.certType;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            ZXSDUploadDetailsResultController *viewController = [ZXSDUploadDetailsResultController new];
            viewController.certType = model.certType;
            viewController.certStatus = model.certStatus;
            viewController.failureDesc = model.certContent;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else if ([model.certType isEqualToString:@"geographicInfo"]) {
        TrackEvent(kLocation);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getLocationPermission];
        });
    }
    else if([model.certType isEqualToString:@"wechantInfo"] ||
            [model.certType isEqualToString:@"wxCompanyInfo"]){
        [URLRouter routerUrlWithPath:GetString(model.url) extra:nil];
    }
    else {
        ZGLog(@"异常点击");
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionBackView = [[UIView alloc] init];
    sectionBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    if (section == 0) {
        sectionBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 48);
        titleLabel.frame = CGRectMake(20, 20, SCREEN_WIDTH()/2, 28);
    } else {
        sectionBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 68);
        titleLabel.frame = CGRectMake(20, 40, SCREEN_WIDTH()/2, 28);
    }
    
    NSString *title = @"";
    if (_channelNameArray.count > section) {
        title = _channelNameArray[section];
    }
    
    titleLabel.text = title;
    titleLabel.textColor = UICOLOR_FROM_HEX(0x3C465A);
    titleLabel.font = FONT_PINGFANG_X_Medium(16);
    
    [sectionBackView addSubview:titleLabel];
    
    return sectionBackView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48.f;
    } else {
        return 68.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _channelModelArray.count - 1) {
        return nil;
    }
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 8)];
    footer.backgroundColor = UICOLOR_FROM_HEX(0xF7F9FB);
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == _channelModelArray.count - 1 ? 0:8;
}


#pragma mark - Location
- (void)getLocationPermission {
    //当前定位服务是否打开
    if(![CLLocationManager locationServicesEnabled]) {
        [self showLocationRestrictedOrDeniedAlertWithMessage:@"请在设置->隐私->定位服务打开定位"];
        return;
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        [self showLocationRestrictedOrDeniedAlertWithMessage:@"请在设置->隐私->定位服务打开定位"];
        return;
    }
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
}

- (void)checkLocationInfomation {
    if([[_locationDic objectForKey:@"latitude"] doubleValue] == 0 || [[_locationDic objectForKey:@"longitude"] doubleValue] == 0) {
        if ([ZXSDUserDefaultHelper readValueForKey:LAST_UPLOAD_LOCATION_DATE]) {
            NSDate *lastDate = (NSDate *)[ZXSDUserDefaultHelper readValueForKey:LAST_UPLOAD_LOCATION_DATE];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval interval = [currentDate timeIntervalSinceDate:lastDate];
            if (interval < 5) {
                [self showToastWithText:@"正在获取位置信息请稍后再试"];
            } else {
                [ZXSDUserDefaultHelper storeValueIntoUserDefault:currentDate forKey:LAST_UPLOAD_LOCATION_DATE];
                [self uploadLocationInfomation];
            }
        } else {
            NSDate *lastDate = [NSDate date];
            [ZXSDUserDefaultHelper storeValueIntoUserDefault:lastDate forKey:LAST_UPLOAD_LOCATION_DATE];
            [self showToastWithText:@"正在获取位置信息请稍后再试"];
        }
    } else {
        [self uploadLocationInfomation];
    }
}

- (void)uploadLocationInfomation {
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    ZGLog(@"===%@",_locationDic);
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager POST:[NSString stringWithFormat:@"%@%@",MAIN_URL,UPLOAD_LOCATION_URL] parameters:_locationDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"提交地理位置信息接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUD];
        [self refreshDataConfigure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];

}

- (void)showLocationRestrictedOrDeniedAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
            [[UIApplication sharedApplication] openURL:settingsUrl];
        }
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//更新用户位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    ZGLog(@"获取定位失败==%@",error.description);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
