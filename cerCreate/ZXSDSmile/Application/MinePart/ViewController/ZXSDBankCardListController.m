//
//  ZXSDBankCardListController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/22.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBankCardListController.h"
#import "UIView+help.h"
#import "CRBoxInputView.h"

#import "CoverBackgroundView.h"

//vc
#import "ZXReservedPhoneUpdateViewController.h"


#import "ZXSDNecessaryCertThirdStepController.h"
#import "ZXSDBankCardModel.h"
#import "ZXSDBankCardCell.h"
#import "EPNetworkManager+Mine.h"

static const NSInteger kMaxRetryTime = 59;


@interface ZXSDBankCardListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) NSMutableArray<ZXSDBankCardItem*> *records;
@property (nonatomic, assign) BOOL isSmile;

@property (nonatomic, strong) CoverBackgroundView *smsCoverbgView;
@property (nonatomic, strong) CRBoxInputView *boxInputView;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) NSString *smsCodeToken;
@property(nonatomic,retain) dispatch_source_t timer;
@property (nonatomic, strong) NSString *inputSmsCode;

@property (nonatomic, strong) ZXSDBankCardItem *selectedCard;



@end

@implementation ZXSDBankCardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    
    self.title = @"银行卡管理";
    self.records = [NSMutableArray new];
    self.isSmile = [[ZXSDCurrentUser currentUser].userRole isEqualToString:@"smile"];
//#warning --test--
//    self.isSmile = NO;
//#warning --test--

    
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    TrackEvent(kMine_bankCard);

    [self fetchRecords];
}

- (void)fetchRecords
{
    [self.records removeAllObjects];
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    
    [EPNetworkManager getUserBankCards:nil completion:^(NSArray<ZXSDBankCardItem *> *records, NSError *error) {
        [self dismissLoadingProgressHUDImmediately];
        [self.mainTable.mj_header endRefreshing];
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        [self.records addObjectsFromArray:records];
        [self.mainTable reloadData];
        
    }];
}

- (UIView *)buildFooter
{
    UIView *footer = [UIView new];
    [footer addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(20);
        make.right.equalTo(footer).offset(-20);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(footer);
    }];
    return footer;
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
/*
    if (!self.isSmile ||
        self.shouldShowBottom) {
*/
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
        self.footerView = bottomView;
        
        [self.view addSubview:self.mainTable];
        [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(bottomView.mas_top);
        }];
/*
    } else {
        [self.view addSubview:self.mainTable];
        [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
    }
*/
    self.mainTable.tableFooterView = [UIView new];
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchRecords];
    }];
    

    [self.mainTable registerClass:[ZXSDBankCardCell class] forCellReuseIdentifier:[ZXSDBankCardCell identifier]];
}

#pragma mark - data handle -
- (void)requestSmsCodeRequestWithCard:(ZXSDBankCardItem*)card{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:card.refId forKey:@"bankRefId"];
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_cardUnbindSendSmscode parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if (response.resultModel.code != 0) {
            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }

        [self showToastWithText:@"验证码已成功发送"];

        self.smsCodeToken = [(NSDictionary*)response.originalContent stringObjectForKey:@"otpCodeToken"];
        
        [self showUnbindPhoneViewWithCard:card];
        [self updateSendCondeButton];

        
    }];
    
}

- (void)requestUnbindWithCard:(ZXSDBankCardItem*)card code:(NSString*)smsCode{
    if (!IsValidString(smsCode)) {
        [EasyTextView showText:@"请输入验证码"];
        return;
    }
    
    if(!IsValidString(card.refId)){
        return;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:smsCode forKey:@"code"];
    [tmps setSafeValue:card.refId forKey:@"bankRefId"];
    
    LoadingManagerShow();
    @weakify(self);

    [EPNetworkManager.defaultManager postAPI:kPath_cardUnbindConfirm parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        @strongify(self);
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if (response.resultModel.code != 0) {
            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }

        [self showToastWithText:@"解绑成功"];
        [CoverBackgroundView hide];
        [self fetchRecords];

    }];
    
    
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXSDBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDBankCardCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZXSDBankCardItem *model = [self.records objectAtIndex:indexPath.row];
    [cell setRenderData:model];
    [cell showBottomLine];
    
    cell.isSmile = self.isSmile;
    cell.mainCard = indexPath.row == 0;
    
//    @weakify(self);
//    [cell setMainCardAction:^{
//        @strongify(self);
//        [self shouldShowChangeAlertViewWithCard:model];
//    }];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    [self optionViewWithItems:[self itemsWithIdx:(int)indexPath.row] idx:indexPath.row];
    
//    if (!self.isSmile && indexPath.row != 0) {
//        ZXSDBankCardItem *model = [self.records objectAtIndex:indexPath.row];
//        [self shouldShowChangeAlertViewWithCard:model];
//    }
    self.selectedCard = nil;
    if (self.isSmile) {
        return;
    }
    
    NSArray *items = [self itemsWithIdx:(int)indexPath.row];
    if (!IsValidArray(items)) {
        return;
    }
    self.selectedCard = [self.records objectAtIndex:indexPath.row];
    [self optionViewWithItems:items idx:(int)indexPath.row];

}

- (NSArray*)itemsWithIdx:(int)idx{
    if (idx == 0) {
        return @[
            /*@"预留手机号更新",
            @"取消",*/
        ];
    }
    else{
        return @[
            @"设为工资卡",
            /*@"预留手机号更新",*/
            @"解除绑定",
            @"取消",
        ];
    }
}

#pragma mark - help methods 0-
- (void)shouldShowChangeAlertViewWithCard:(ZXSDBankCardItem *)model{
    if (model.wageFlowIsValid) {
        [self bindMainCard:model];
        return;
    }
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColor.whiteColor;
    ViewBorderRadius(contentView, 12, 1, UIColor.whiteColor);
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = FONT_PINGFANG_X_Medium(18);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = TextColorTitle;
    titleLab.text = @"变更默认工资卡";
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.centerX.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.numberOfLines = 0;
    contentLab.font = FONT_PINGFANG_X(14);
    contentLab.textColor = TextColorSubTitle;
    contentLab.text = @"当前默认工资卡还未完成认证，变更需重新上传工资明细，以及重新进行审核，将会影响您本次预支。\n确认需要更换默认工资卡吗？";
    [contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).inset(20);
        make.left.right.inset(20);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = TextColorDisable;
    ViewBorderRadius(cancelBtn, 22, 0.01, UIColor.whiteColor);
    [cancelBtn setTitleColor:TextColorTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT_PINGFANG_X(14);
    [cancelBtn setTitle:@"放弃" forState:UIControlStateNormal];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.inset(20);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *cofirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cofirmBtn.backgroundColor = kThemeColorMain;
    ViewBorderRadius(cofirmBtn, 22, 0.01, UIColor.whiteColor);
    [cofirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    cofirmBtn.titleLabel.font = FONT_PINGFANG_X(14);
    [cofirmBtn setTitle:@"确认更换" forState:UIControlStateNormal];
    @weakify(self);
    [cofirmBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [CoverBackgroundView hide];

        [self bindMainCard:model];
    } forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cofirmBtn];
    [cofirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right).inset(16);
        make.bottom.right.inset(20);
        make.width.height.mas_equalTo(cancelBtn);
    }];

    
    CoverBackgroundView *bgView = [CoverBackgroundView instanceWithContentView:contentView mode:CoverViewShowModeCenter viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(40);
        make.height.mas_equalTo(245);
        make.centerY.offset(0);
    }];
    
}

#pragma mark - Action
- (void)bindMainCard:(ZXSDBankCardItem *)model
{
    if (model.refId.length == 0) {
        return;
    }
    
    [self showLoadingProgressHUDWithText:@"正在加载..."];
    [EPNetworkManager bindHostBankCard:model.refId completion:^(NSError *error) {
        [self dismissLoadingProgressHUDImmediately];
        
        if (!error) {
            [self fetchRecords];

        } else {
            [self handleRequestError:error];
        }
    }];
}

- (void)addBankCard
{
    ZXSDNecessaryCertThirdStepController *vc = [ZXSDNecessaryCertThirdStepController new];
    vc.backViewController = self;
    vc.addCardMode = YES;
    vc.customTitle = @"添加银行卡";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.estimatedRowHeight = 140;
        _mainTable.backgroundColor = UIColor.whiteColor;

    }
    return _mainTable;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmButton setImage:UIImageNamed(@"icon_mine_bankAdd") forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [_confirmButton addTarget:self action:@selector(addBankCard) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmButton setTitle:@"添加工资卡" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = FONT_PINGFANG_X_Medium(16);
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    }
    return _confirmButton;
}

#pragma mark - help methods -

- (UIView*)optionViewWithItems:(NSArray*)items idx:(int)itemIndex{
    
    CGFloat itemHeight = 53;
    CGFloat optionHeight = items.count*itemHeight+10 + kBottomSafeAreaHeight;
    UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), optionHeight)];
    optionView.backgroundColor = UIColor.whiteColor;
    [optionView addRoundedCornerWithRadius:16 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    for (int idx = 0; idx<items.count; idx++) {
        NSString*  obj = items[idx];
        UIButton *itemBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(16) title:obj];
        [itemBtn setTitleColor:TextColorTitle forState:UIControlStateNormal];
        [optionView addSubview:itemBtn];
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat lHeight = 0;
            if (idx == items.count - 1) {
                lHeight = 10;
                UILabel *sepLine = [[UILabel alloc] init];
                sepLine.backgroundColor = kThemeColorBg;
                [optionView addSubview:sepLine];
                [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(idx*itemHeight);
                    make.left.right.inset(0);
                    make.height.mas_equalTo(8);
                }];
            }

            make.top.inset(idx*itemHeight+lHeight);
            make.left.right.inset(0);
            make.height.mas_equalTo(itemHeight);
        }];
        itemBtn.tag = idx;
        
        @weakify(self);
        [itemBtn bk_addEventHandler:^(UIButton *sender) {
            @strongify(self);
            [CoverBackgroundView hide];
            ZXSDBankCardItem *model = [self.records objectAtIndex:itemIndex];

            if ([sender.currentTitle isEqualToString:@"设为工资卡"]) {
                [self shouldShowChangeAlertViewWithCard:model];
            }
            else if ([sender.currentTitle isEqualToString:@"预留手机号更新"]){
                ZXReservedPhoneUpdateViewController *phoneVC = [[ZXReservedPhoneUpdateViewController alloc] init];
                phoneVC.card = model;
                phoneVC.isMainCard = itemIndex == 0;
                [self.navigationController pushViewController:phoneVC animated:YES];
            }
            else if ([sender.currentTitle isEqualToString:@"解除绑定"]){
                [self requestSmsCodeRequestWithCard:model];
            }
            else if ([sender.currentTitle isEqualToString:@"取消"]){
                
            }

        } forControlEvents:UIControlEventTouchUpInside];

    }
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:optionView mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(optionHeight);
    }];
    cover.bgViewUserEnable = NO;
    
    
    return optionView;
}


- (void)showUnbindPhoneViewWithCard:(ZXSDBankCardItem*)card{
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), SCREEN_WIDTH())];
    containerView.backgroundColor = UIColor.whiteColor;
    [containerView addRoundedCornerWithRadius:16 corners:UIRectCornerTopLeft|UIRectCornerTopRight];

    UIView *titleView = [[UIView alloc] init];
    [containerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:UIImageNamed(@"icon_close") forState:UIControlStateNormal];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(0);
        make.left.inset(0);
        make.width.mas_equalTo(56);
    }];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [UILabel labelWithText:@"请输入短信验证码" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(16)];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(13);
        make.centerX.offset(0);
        make.height.mas_equalTo(16);
    }];
    self.boxInputView = [self generateCustomBoxInputView];
    [containerView addSubview:self.boxInputView];
    [self.boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(64);
        make.left.right.inset(24);
        make.height.mas_equalTo(56);
    }];
    @weakify(self);
    self.boxInputView.textEditStatusChangeblock = ^(CRTextEditStatus editStatus) {
        @strongify(self);

        if (editStatus == CRTextEditStatus_BeginEdit) {

            dispatch_queue_after_S(0.5, ^{
                [self.smsCoverbgView contentViewHeight:SCREEN_WIDTH()+80];
            });
            
        }
        else{
            [self.smsCoverbgView contentViewHeight:SCREEN_WIDTH()];

        }
    };
    _boxInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
        @strongify(self);
        if (isFinished && text.length > 0) {
            self.inputSmsCode = text;
            [self requestUnbindWithCard:card code:text];
        }
    };
    
    _sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendCodeButton.backgroundColor = [UIColor clearColor];
    [_sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [_sendCodeButton setTitleColor:kThemeColorMain forState:UIControlStateNormal];
    [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _sendCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    _sendCodeButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _sendCodeButton.userInteractionEnabled = YES;
    [containerView addSubview:_sendCodeButton];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(20);
        make.top.mas_equalTo(self.boxInputView.mas_bottom).inset(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *unbindConfirBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(16) title:@"确定" textColor:UIColor.whiteColor];
    [unbindConfirBtn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
    [containerView addSubview:unbindConfirBtn];
    ViewBorderRadius(unbindConfirBtn, 25, 0.1, UIColor.whiteColor);
    [unbindConfirBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.inset(kBottomSafeAreaHeight+30);
        make.left.right.inset(60);
        make.height.mas_equalTo(50);
    }];
    
    [unbindConfirBtn bk_addEventHandler:^(id sender) {
        [self requestUnbindWithCard:card code:self.inputSmsCode];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.smsCoverbgView = [CoverBackgroundView instanceWithContentView:containerView mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_WIDTH());
    }];
    self.smsCoverbgView.bgViewUserEnable = NO;
    
}

- (CRBoxInputView *)generateCustomBoxInputView{
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellBgColorNormal = UIColorFromHex(0xEAEFF2);
    cellProperty.cellBgColorSelected = UIColorFromHex(0xEAEFF2);
    cellProperty.cellCursorWidth = 3.0;
    cellProperty.cellCursorHeight = 24.0;
    cellProperty.cellCursorColor = kThemeColorMain;
    cellProperty.cornerRadius = 4;
    cellProperty.borderWidth = 0;
    cellProperty.cellFont = FONT_SFUI_X_Regular(20);
    cellProperty.cellTextColor = UICOLOR_FROM_HEX(0x333333);

    cellProperty.configCellShadowBlock = ^(CALayer * _Nonnull layer) {
        layer.shadowColor = UIColorFromHex(0xEAEFF2).CGColor;
        layer.shadowOpacity = 1;
        layer.shadowOffset = CGSizeMake(0, 2);
        layer.shadowRadius = 4;
    };

    CRBoxInputView *boxInputView = [[CRBoxInputView alloc] init];
//    _boxInputView.boxFlowLayout.itemSize = CGSizeMake(XX_6(52), XX_6(52));
    
    boxInputView.frame = CGRectMake(25, 64, SCREEN_WIDTH() - 50, 60);
    boxInputView.codeLength = 6;

    boxInputView.customCellProperty = cellProperty;
    [boxInputView loadAndPrepareViewWithBeginEdit:YES];
    return boxInputView;
}


#pragma mark - data handle -

//重新发送验证码
- (void)sendCodeButtonClicked:(UIButton *)btn {
    btn.userInteractionEnabled = NO;

    [self requestSmsCodeRequestWithCard:self.selectedCard];

}

- (void)updateSendCondeButton {
    
    if(self.timer){
        return;
    }
    
    __block NSInteger timeout = kMaxRetryTime;
    dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        if (timeout <= 0) {
            dispatch_source_cancel(self.timer);
            self.timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButton.userInteractionEnabled = YES;
                [self.sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout % (timeout + 1);
            NSString *stringTime = [NSString stringWithFormat:@"%ld",(long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCodeButton.userInteractionEnabled = NO;
                [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%@ s", stringTime] forState:UIControlStateNormal];
            });
            timeout --;
        }
    });
    dispatch_resume(_timer);
}



@end
