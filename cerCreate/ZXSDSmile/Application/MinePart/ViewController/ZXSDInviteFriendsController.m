//
//  ZXSDInviteFriendsController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDInviteFriendsController.h"
#import "CoverBackgroundView.h"

#import <WXApi.h>

#import "ZXWithdrawViewController.h"
#import "ZXSDWithdrawRecordsController.h"
#import "ZXSDInviteRecordsController.h"
#import "ZXSDIdentityCardVerifyController.h"
#import "ZXSDLivingDetectionController.h"

#import <SDWebImage/SDWebImage.h>
#import "ZXSDInviteCardCell.h"
#import "ZXSDInviteRulesCell.h"
#import "ZXSDInviteRecordsCell.h"
#import "ZXSDInviteInfoModel.h"

#import "ZXShareActionView.h"
#import "EPNetworkManager.h"
#import "ZXShareInfoModel.h"


@interface ZXSDInviteFriendsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *withdrawButton;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIImageView *playbillImageView;

@property (nonatomic, strong) ZXSDInviteInfoModel *infoModel;
@property (nonatomic, strong) NSArray<ZXSDInviteItem*> *records;
@property (nonatomic, copy) NSString *shareQRURL;

@property (nonatomic, strong) ZXShareInfoModel *shareInfo;

@end

@implementation ZXSDInviteFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    self.title = @"邀请好友";
    [self addUserInterfaceConfigure];
    [self requestShareInfo:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    TrackEvent(kInvitation);
    
    [self prepareDataConfigure];
    [self fetchInviteRecords];
}

#pragma mark - data handle -

- (void)requestShareInfo:(BOOL)loading{
    if (loading) {
        LoadingManagerShow();
    }
    
    [[EPNetworkManager defaultManager] getAPI:kShareInfoPath parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            if (loading) {
                [self handleRequestError:error];
            }
            return;
        }
        
        NSDictionary *result = response.originalContent;
        if (!IsValidDictionary(result)) {
            return;
        }
        
        self.shareInfo = [ZXShareInfoModel instanceWithDictionary:result];
        if (loading) {
            [self showShareActionView];
        }
        
    }];
}

- (void)prepareDataConfigure
{
    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] getAPI:USER_INVITE_DETAIL_URL parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            return;
        }
        
        NSDictionary *dic = (NSDictionary*)response.originalContent;
        if (!IsValidDictionary(dic)) {
            return;
        }
        
        self.infoModel = [ZXSDInviteInfoModel modelWithJSON:response.originalContent];
        
//#warning --test--
//        self.infoModel.balance = 2000;
//    self.infoModel.balanceLeft = 1000;
//#warning --test--

        
        [self.mainTable reloadData];
    }];
    
}


- (void)fetchInviteRecords
{
    NSDictionary *params = @{
        @"offset": @0,
        @"limit": @10,
    };
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,USER_INVITELIST_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"邀请记录接口成功返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *listArray = [responseObject objectForKey:@"resultList"];
            self.records = [NSArray yy_modelArrayWithClass:[ZXSDInviteItem class] json:listArray];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self showNetworkErrowAlertView:task andError:error andDefaultTitle:@""];
    }];
}

- (void)fetchShareQrInfo:(void (^)(UIImage *shareImage))completion
{
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,USER_QRCODE_URL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZGLog(@"获取分享海报接口成功返回数据---%@",responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *shareQRURL = [responseObject objectForKey:@"qrCodeUrl"];
            [ZXSDCurrentUser currentUser].shareQRURL = shareQRURL;
            
            if (shareQRURL.length > 0) {
                [ZXSDPublicClassMethod prefetchImages:@[shareQRURL] completed:^(NSArray<UIImage *> * _Nullable images, BOOL allFinished) {
                    
                    [self dismissLoadingProgressHUDImmediately];
                    
                    if (allFinished && images.count > 0) {
                        completion(images[0]);
                    } else {
                        completion(nil);
                    }
                    
                }];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissLoadingProgressHUDImmediately];
        completion(nil);
        
    }];
}


- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    [self.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
       if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

- (void)addUserInterfaceConfigure
{
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_invite_head"]];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_WIDTH()*(886.0/828.0));
    header.contentMode = UIViewContentModeScaleAspectFill;
    self.mainTable.tableHeaderView = header;
    
    UIView *bottomView = [self buildFooter];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view).with.offset(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [self.mainTable registerClass:[ZXSDInviteCardCell class] forCellReuseIdentifier:[ZXSDInviteCardCell identifier]];
    [self.mainTable registerClass:[ZXSDInviteRulesCell class] forCellReuseIdentifier:[ZXSDInviteRulesCell identifier]];
    [self.mainTable registerClass:[ZXSDInviteRecordsCell class] forCellReuseIdentifier:[ZXSDInviteRecordsCell identifier]];
}

- (UIView *)buildFooter
{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    
    [footerView addSubview:self.confirmButton];
    [footerView addSubview:self.withdrawButton];
    
    [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(self.confirmButton.mas_left).offset(-20);
        make.top.equalTo(footerView).offset(10);
        make.height.mas_equalTo(44);
    
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawButton.mas_right).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.top.equalTo(footerView).offset(10);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.withdrawButton);
    }];
    
    self.footerView = footerView;
    return footerView;
}
#pragma mark - help methods -

- (void)depositActionWithInfo:(ZXSDInviteInfoModel*)info
{

    if ([info.action isEqualToString: ZXSDHomeUserApplyStatus_IDCARD_UPLOAD]) {
        TrackEvent(kAuth_idCard);

        ZXSDIdentityCardVerifyController * vc = [ZXSDIdentityCardVerifyController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([info.action isEqualToString: ZXSDHomeUserApplyStatus_PREPARE_FACE]) {
        TrackEvent(kAuth_face);

        ZXSDLivingDetectionController *vc = [ZXSDLivingDetectionController new];
        vc.backViewController = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if (!self.infoModel || self.infoModel.balanceLeft <= 0) {
            [self showToastWithText:@"可提现的金额不足，赶快去邀请好友吧"];
            return;
        }

        ZXWithdrawViewController *vc = [[ZXWithdrawViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

#pragma mark - action methods -


- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sharePlaybillAction
{

    if ([WXApi isWXAppInstalled]) {
        
        if (!self.shareInfo) {
            [self requestShareInfo:YES];
            return;
        }
        
        [self showShareActionView];

        return;
    }

    [self showOldSystemShareView];
}
- (void)showOldSystemShareView{
    NSString *url = [[ZXSDCurrentUser currentUser] shareQRURL];
    if (url.length == 0) {
        [self fetchShareQrInfo:^(UIImage *shareImage) {
            if (shareImage) {
                [self preparePlaybillForShare:shareImage];
            } else {
                [self showToastWithText:@"请稍后重新尝试"];
            }
        }];
       
    } else {
        NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
        if (!image) {
            [self showLoadingProgressHUDWithText:@"正在加载..."];
            [ZXSDPublicClassMethod prefetchImages:@[url] completed:^(NSArray<UIImage *> * _Nullable images, BOOL allFinished) {
                
                [self dismissLoadingProgressHUDImmediately];
                if (allFinished && images.count > 0) {
                    UIImage *shareImage = images[0];
                    [self preparePlaybillForShare:shareImage];
                    
                } else {
                    [self showToastWithText:@"请稍后重新尝试"];
                }
            }];
            
        } else {
            [self preparePlaybillForShare:image];
        }
    }

}
- (void)preparePlaybillForShare:(UIImage *)shareImage
{
    // show preview
    UIView *maskView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.navigationController.view addSubview:maskView];
    
    [self.navigationController.view addSubview:self.playbillImageView];
    self.playbillImageView.image = shareImage;
    [self.playbillImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationController.view).offset(38);
        make.right.equalTo(self.navigationController.view).offset(-38);
        make.top.equalTo(self.navigationController.view).offset(35);
        make.height.equalTo(self.playbillImageView.mas_width).multipliedBy(599.0/338.0);
    }];
    
    NSArray *activityItemsArray = @[shareImage];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems: activityItemsArray applicationActivities:nil];
    activityVC.modalInPopover = YES;
    activityVC.excludedActivityTypes = @[
                                             UIActivityTypePostToFacebook,
                                             UIActivityTypePostToTwitter,
                                             UIActivityTypePostToWeibo,
                                             UIActivityTypeMessage,
                                             UIActivityTypeMail,
                                             UIActivityTypePrint,
                                             UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,
                                             UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypeAddToReadingList,
                                             UIActivityTypePostToFlickr,
                                             UIActivityTypePostToVimeo,
                                             UIActivityTypePostToTencentWeibo,
                                             UIActivityTypeAirDrop,
                                             UIActivityTypeOpenInIBooks
                                             ];
    UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError)
    {
        ZGLog(@"activityType == %@",activityType);
        if (completed == YES) {
            ZGLog(@"share completed");
        } else {
            ZGLog(@"share cancel");
        }
        
        [maskView removeFromSuperview];
        [self.playbillImageView removeFromSuperview];
    };
    
    activityVC.completionWithItemsHandler = itemsBlock;
    
    [self presentViewController:activityVC animated:YES completion:^{
        
    }];
}
///我要提现
- (void)withdrawAction
{

//    if (![ZXSDCurrentUser currentUser].isCertified) {
//        [self showToastWithText:@"请先完成认证，再来提现哦"];
//        return;
//    }
    [self depositActionWithInfo:self.infoModel];
    
}



- (void)showWithdrawHistory
{
    ZXSDWithdrawRecordsController *vc = [ZXSDWithdrawRecordsController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookupMoreInviteRecords
{
    ZXSDInviteRecordsController *vc = [ZXSDInviteRecordsController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - help methods -

- (void)showShareActionView{
    if (!self.shareInfo) {
        return;
    }
    
    ZXShareActionView *shareView = [[ZXShareActionView alloc] init];
    shareView.shareType = ZXShareTypeImage;
    
    ZXShareModel *model = [[ZXShareModel alloc] init];
    model.title = self.shareInfo.title;
    model.desc = self.shareInfo.describe;
    model.link = self.shareInfo.shareUrl;
    model.image = self.shareInfo.qrCodeUrl;
    shareView.shareModel = model;
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:shareView mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(ShareViewHeight());
    }];
    cover.bgViewUserEnable = NO;

}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = nil;
    if (indexPath.row == 0) {
        cellIdentifier = [ZXSDInviteCardCell identifier];
    } else if (indexPath.row == 1) {
        cellIdentifier = [ZXSDInviteRulesCell identifier];
    } else {
        cellIdentifier = [ZXSDInviteRecordsCell identifier];
    }
    
    ZXSDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(self);
    if ([cellIdentifier isEqualToString:[ZXSDInviteRecordsCell identifier]]) {
        
        ZXSDInviteRecordsCell *rcell = (ZXSDInviteRecordsCell *)cell;
        rcell.records = self.records;
        [rcell setMoreAction:^{
            @strongify(self);
            [self lookupMoreInviteRecords];
        }];
        
    } else if ([cellIdentifier isEqualToString:[ZXSDInviteCardCell identifier]]) {
        ZXSDInviteCardCell *card = (ZXSDInviteCardCell *)cell;
        [card setHistoryAction:^{
            @strongify(self);
            [self showWithdrawHistory];
        }];
    }
    
    [cell setRenderData:self.infoModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


#pragma mark - Getter

- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.estimatedRowHeight = 90;
        _mainTable.backgroundColor = UIColor.whiteColor;

    }
    return _mainTable;
}


- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = kThemeColorMain;
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(sharePlaybillAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmButton setTitle:@"分享" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (UIButton *)withdrawButton
{
    if (!_withdrawButton) {
        _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _withdrawButton.backgroundColor = UICOLOR_FROM_HEX(0xF5F5F5);
        [_withdrawButton setTitleColor:UICOLOR_FROM_HEX(0x666666) forState:UIControlStateNormal];
        [_withdrawButton addTarget:self action:@selector(withdrawAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_withdrawButton setTitle:@"我要提现" forState:UIControlStateNormal];
        _withdrawButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _withdrawButton.layer.cornerRadius = 22.0;
        _withdrawButton.layer.masksToBounds = YES;
    }
    return _withdrawButton;
}

- (UIImageView *)playbillImageView
{
    if (!_playbillImageView) {
        _playbillImageView = [UIImageView new];
        _playbillImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _playbillImageView;
}

@end
