//
//  ZXSDLivingDetectionController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDLivingDetectionController.h"
#import "ZXSDNecessaryCertThirdStepController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CJLabel.h"
#import "ZXSDVerifyManager.h"
#import <RPSDK/RPSDK.h>
#import "ZXSDVerifyProgressCell.h"
#import "ZXSDDetectionHeadCell.h"
#import "ZXSDDetectionHintCell.h"

//vc
#import "ZXResultNoteViewController.h"

#import "EPNetworkManager.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeProgress,
    SectionTypeHeader,
    SectionTypeNote,
    SectionTypeAll
};

static const NSString *QUERY_FACE_CERT_TOKEN_URL = @"/rest/idCard/face/token";
static const NSString *VERIFY_FACE_CERT_URL = @"/rest/idCard/face/verify?bizId=";

@interface ZXSDLivingDetectionController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) CJLabel *protocolLabel;

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, copy)NSString *bizId, *token;

@end

@implementation ZXSDLivingDetectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份认证";
    [self requestFaceToken];
    [RPSDK setup];
    [self addUserInterfaceConfigure];

}

#pragma mark - data handle 0 -

- (void)requestFaceToken{
    
    if (self.detectType == LivingDetectionTypeDefault) {
        [self prepareDataConfigure];
    }
    else if(self.detectType == LivingDetectionTypePhoneUpdate){
        [self requestPhoneUpdateFaceToken];
    }
    else if(self.detectType == LivingDetectionTypeChangePhone){
        [self requestNoNamePhoneUpdateFaceToken];
    }
    
}

- (void)prepareDataConfigure
{
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_FACE_CERT_TOKEN_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取人脸识别token接口成功返回数据---%@",responseObject);
        [self dismissLoadingProgressHUDImmediately];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.bizId = [[responseObject objectForKey:@"bizId"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"bizId"];
            self.token = [[responseObject objectForKey:@"token"] isKindOfClass:[NSNull class]] ? @"" : [responseObject objectForKey:@"token"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self addUserInterfaceConfigure];
//            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)requestPhoneUpdateFaceToken{
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_phoneUpdateGetToken parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            if (IsValidString(response.resultModel.responseMsg)) {
                [self showToastWithText:response.resultModel.responseMsg];
            }
            return;
        }
        
        self.bizId = [(NSDictionary*)response.resultModel.data stringObjectForKey:@"bizId"];
        self.token = [(NSDictionary*)response.resultModel.data stringObjectForKey:@"token"];
    }];
}

- (void)requestNoNamePhoneUpdateFaceToken{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.userRefId forKey:@"userRefId"];
    [tmps setSafeValue:self.phone forKey:@"newPhone"];
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_changePhoneUpdateGetToken parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            if (IsValidString(response.resultModel.responseMsg)) {
                [self showToastWithText:response.resultModel.responseMsg];
            }
            return;
        }
        
        self.bizId = [(NSDictionary*)response.resultModel.data stringObjectForKey:@"bizId"];
        self.token = [(NSDictionary*)response.resultModel.data stringObjectForKey:@"token"];
    }];
}




- (UIView *)footerView
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *check = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected") highlightedImage:nil];
    check.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -20, -20, -15);
    [check addTarget:self action:@selector(checkProtocol:) forControlEvents:(UIControlEventTouchUpInside)];
    [footerView addSubview:check];
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.width.height.mas_equalTo(20);
        make.top.equalTo(footerView).offset(0);
    }];
    
    [footerView addSubview:self.protocolLabel];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(check.mas_right).offset(16);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(check);
    }];
    
    [footerView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.top.equalTo(self.protocolLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(44);
    }];
    
    return footerView;
}

- (void)addUserInterfaceConfigure
{
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    UIView *tFooterView = [self footerView];
    tFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 142);
    self.infoTableView.tableFooterView = tFooterView;

    

    [self.infoTableView registerClass:[ZXSDVerifyProgressCell class] forCellReuseIdentifier:[ZXSDVerifyProgressCell identifier]];
    [self.infoTableView registerClass:[ZXSDDetectionHeadCell class] forCellReuseIdentifier:[ZXSDDetectionHeadCell identifier]];
    [self.infoTableView registerClass:[ZXSDDetectionHintCell class] forCellReuseIdentifier:[ZXSDDetectionHintCell identifier]];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SectionTypeProgress &&
        (self.detectType == LivingDetectionTypePhoneUpdate ||
        self.detectType == LivingDetectionTypeChangePhone)) {
        return 0;
    }
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionTypeProgress) {
        ZXSDVerifyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyProgressCell identifier] forIndexPath:indexPath];
        ZXSDVerifyActionModel *model = [ZXSDVerifyManager livingDetectionAction];
        [cell setRenderData:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if(indexPath.section == SectionTypeHeader){
        ZXSDDetectionHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDDetectionHeadCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if(indexPath.section == SectionTypeNote){
        ZXSDDetectionHintCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDDetectionHintCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [UITableViewCell new];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZXSDVerifyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDVerifyProgressCell identifier] forIndexPath:indexPath];
            ZXSDVerifyActionModel *model = [ZXSDVerifyManager livingDetectionAction];
            [cell setRenderData:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            ZXSDDetectionHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDDetectionHeadCell identifier] forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    } else {
        ZXSDDetectionHintCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDDetectionHintCell identifier] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else if(indexPath.section == SectionTypeHeader){
        return [ZXSDDetectionHeadCell height];
    }
    else if(indexPath.section == SectionTypeNote){
        return [ZXSDDetectionHintCell height];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == SectionTypeHeader) {
        if (self.detectType == LivingDetectionTypePhoneUpdate) {
            return 0;
        }
        return 8;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == SectionTypeHeader) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 8)];
        footer.backgroundColor = kThemeColorLine;

        return footer;
    }
    
    return nil;
}

#pragma mark - Action

- (void)nextVerifyAction
{
//#warning --test--
//    [self jumpToNecessaryCertThirdStepController];
//    return;
//#warning --test--

    
    RPConfiguration *configuration = [RPConfiguration configuration];
    configuration.shouldAlertOnExit = YES;
    configuration.shouldWaitResult = YES;
    
    [RPSDK startByNativeWithVerifyToken:_token viewController:self configuration:configuration progress:^(RPPhase phase) {
        
    } completion:^(RPResult * _Nonnull result) {
        
        //建议接入方调用实人认证服务端接口DescribeVerifyResult，
        //来获取最终的认证状态，并以此为准进行业务上的判断和处理。
        ZGLog(@"实人认证结果：%@", result);
        switch (result.state) {
            case RPStatePass:
                // 认证通过。
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self uploadFaceInformation];
                });
            }
                break;
            case RPStateFail:
            {
                // 认证不通过。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self uploadFaceInformation];
                });
            }
                break;
            case RPStateNotVerify:
            {
                // 未认证。
                // 通常是用户主动退出或者姓名身份证号实名校验不匹配等原因导致。
                // 具体原因可通过result.errorCode和result.message来区分（详见错误码说明）。
            }
                break;
        }
    }];
}
#pragma mark - data handle 1 -

- (void)uploadFaceInformation {

    ///换绑手机号的认证提交
    if (self.detectType == LivingDetectionTypePhoneUpdate) {
        [self phoneUpdateFaceVerifyRequest];
        return;
    }
    
    if(self.detectType == LivingDetectionTypeChangePhone){
        [self changePhoneFaceVerifyRequest];
        return;
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeHttp];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json",nil];
    [manager POST:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,VERIFY_FACE_CERT_URL,_bizId] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dismissLoadingProgressHUD];
        NSString *resultString =  [[NSString alloc]initWithData: responseObject encoding:NSUTF8StringEncoding];
        ZGLog(@"提交人脸识别信息接口成功返回数据---%@",resultString);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self jumpToNecessaryCertThirdStepController];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUD];
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@"识别失败"];
    }];
}

- (void)phoneUpdateFaceVerifyRequest{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.bizId forKey:@"bizId"];
    [tmps setSafeValue:self.phone forKey:@"newPhone"];
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_phoneUpdateFaceVerify parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            if (IsValidString(response.resultModel.responseMsg)) {
                [self showToastWithText:response.resultModel.responseMsg];
            }
            
            return;
        }
        
        [self jumpToNecessaryCertThirdStepController];
        
    }];
}

- (void)changePhoneFaceVerifyRequest{

    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:self.bizId forKey:@"bizId"];
    [tmps setSafeValue:self.phone forKey:@"newPhone"];
    [tmps setSafeValue:self.userRefId forKey:@"userRefId"];
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_changePhoneUpdateFaceVerify parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            if (IsValidString(response.resultModel.responseMsg)) {
                [self showToastWithText:response.resultModel.responseMsg];
            }
            
            return;
        }
        ToastShow(@"更换手机号成功");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)jumpToNecessaryCertThirdStepController
{
    if (self.detectType == LivingDetectionTypePhoneUpdate) {
        ZXResultNoteViewController *resultVC = [[ZXResultNoteViewController alloc] init];
        resultVC.resultPageType = ResultPageTypePhoneUpdate;
        [self.navigationController pushViewController:resultVC animated:YES];
        return;
    }
    
    [self backButtonClicked:nil];

/*
    // 根据当前业务模式选择下一步具体内容
    if ([ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery) {
        [self backButtonClicked:nil];
    } else {
        ZXSDNecessaryCertThirdStepController *viewController = [ZXSDNecessaryCertThirdStepController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
*/
    
}

- (void)jumpToZXSDProtocolController
{
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PERSONAL_INFO_AGREEMENT_URL];
    
    viewController.title = @"个人信息授权协议";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)checkProtocol:(UIButton *)sender
{
    _checked = !_checked;
    UIImage *image = _checked ?UIIMAGE_FROM_NAME(@"smile_loan_agreement_selected") :UIIMAGE_FROM_NAME(@"smile_loan_agreement_unselected");
    [sender setImage:image forState:UIControlStateNormal];
    
    self.nextButton.userInteractionEnabled = _checked;
    self.nextButton.backgroundColor = _checked ? kThemeColorMain : UICOLOR_FROM_HEX(0xF5F5F5);
    [self.nextButton setTitleColor:_checked ? [UIColor whiteColor] : UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
}


#pragma mark - Getter

- (UIButton *)nextButton
{
    if (!_nextButton) {
           _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
           _nextButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
           [_nextButton setTitleColor:UICOLOR_FROM_HEX(0xCCCCCC) forState:UIControlStateNormal];
           [_nextButton addTarget:self action:@selector(nextVerifyAction) forControlEvents:(UIControlEventTouchUpInside)];
           
           [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
           _nextButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
           _nextButton.layer.cornerRadius = 22.0;
           _nextButton.layer.masksToBounds = YES;
       }
       return _nextButton;
}

- (UITableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _infoTableView.backgroundColor = UIColor.whiteColor;
        _infoTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _infoTableView.backgroundColor = [UIColor whiteColor];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.showsVerticalScrollIndicator = YES;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.tableFooterView = [UIView new];
    }
    return _infoTableView;
    
}

- (CJLabel *)protocolLabel
{
    if (!_protocolLabel) {
        NSString *protocolString = @"阅读即代表已同意《个人信息授权协议》并确认授权";
        UIFont *currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        if (iPhone4() || iPhone5()) {
            currentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11.0];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protocolString];
        _protocolLabel = [[CJLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT() - 40 - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20)];
        if (iPhoneXSeries()) {
            CGFloat safeAreaHeight = 34;
            _protocolLabel.frame = CGRectMake(20, SCREEN_HEIGHT() - 40 - safeAreaHeight - NAVIBAR_HEIGHT(), SCREEN_WIDTH() - 40, 20);
        }
        _protocolLabel.numberOfLines = 0;
        _protocolLabel.textAlignment = NSTextAlignmentCenter;
        
        WEAKOBJECT(self);
        attributedString = [CJLabel configureAttributedString:attributedString
                                                      atRange:NSMakeRange(0, attributedString.length)
                                                   attributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x999999),
                                                       NSFontAttributeName:currentFont,
                                                   }];
        
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"《个人信息授权协议》"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x4472C4),
                                                       NSFontAttributeName:currentFont,
                                                   }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToZXSDProtocolController];
        }longPressBlock:^(CJLabelLinkModel *linkModel){
            [weakself jumpToZXSDProtocolController];
        }];
        _protocolLabel.attributedText = attributedString;
        _protocolLabel.extendsLinkTouchArea = YES;
    }
    return _protocolLabel;
}

@end
