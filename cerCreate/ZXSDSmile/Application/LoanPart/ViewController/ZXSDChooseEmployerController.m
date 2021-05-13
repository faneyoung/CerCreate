//
//  ZXSDChooseEmployerController.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDChooseEmployerController.h"
#import "ZXSDChooseEmployerCell.h"
#import "ZXSDCompanyModel.h"
#import "ZXSDBaseTabBarController.h"
#import "ZXSDVerifyUserinfoController.h"
#import "ZXSDLoginService.h"

//vc
#import "ZXExistNoteViewController.h"


//views
#import "ZXChooseCompanyCell.h"

#import "EPNetworkManager.h"
#import "ZXCompanyCheckModel.h"


static const NSString *QUERY_COMPANYS_URL = @"/rest/company/list";
static const NSString *EMPLOYER_UPDATE_COMPANYNAME_URL = @"/rest/userInfo/companyInfo";

@interface ZXSDChooseEmployerController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSMutableArray *chooseModels;

@property (nonatomic, strong) ZXSDCompanyModel *otherCompany;
@property (nonatomic, strong) ZXSDCompanyModel *selectedCompany;


@end

@implementation ZXSDChooseEmployerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择身份";
        
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (NSMutableArray*)chooseModels{
    if (!_chooseModels) {
        _chooseModels = [NSMutableArray arrayWithCapacity:2];
    }
    return _chooseModels;
}

- (ZXSDCompanyModel *)otherCompany{
    if (!_otherCompany) {
        ZXSDCompanyModel *fake = [ZXSDCompanyModel new];
        fake.shortName = @"我是个人用户";
        //fake.logoUrl = @"mine_invite";
        fake.companyRefId = @"0000";
        fake.selecteStatus = YES;
        _otherCompany = fake;

    }
    return _otherCompany;
}

- (void)prepareDataConfigure
{

    ZXCompanySelectionModel *model = [[ZXCompanySelectionModel alloc] init];
    model.title = @"我是互联网用户";
    model.selected = YES;
    [self.chooseModels addObject:model];
    self.selectedCompany = self.otherCompany;
    
    AFHTTPSessionManager *manager = [ZXSDPublicClassMethod getAFSessionManagerWithRequestType:AFSerializerTypeJson andResponseType:AFSerializerTypeJson];
    LoadingManagerShow();
    [manager GET:[NSString stringWithFormat:@"%@%@",MAIN_URL,QUERY_COMPANYS_URL] parameters:@{@"filter": @(true)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LoadingManagerHidden();
        ZGLog(@"获取内部公司信息接口成功返回数据---%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            ZXCompanySelectionModel *model = [[ZXCompanySelectionModel alloc] init];
            model.title = @"我是薪朋友合作企业用户";
            model.companys = [NSArray yy_modelArrayWithClass:[ZXSDCompanyModel class] json:responseObject];
            [self.chooseModels addObject:model];
            
            [self.mainTable reloadData];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LoadingManagerHidden();

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

- (void)addUserInterfaceConfigure
{
    UIView *bottomView = [self buildFooter];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(kBottomSafeAreaHeight+20);
        make.height.mas_equalTo(64);
        
    }];
    self.footerView = bottomView;
    
    /*
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 80)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel labelWithText:@"选择您的雇主企业" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(28)];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.centerY.mas_equalTo(0);
    }];
    
    self.mainTable.tableHeaderView = headerView;
     */
    
    [self.view addSubview:self.mainTable];
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [self.mainTable registerClass:[ZXSDChooseEmployerCell class] forCellReuseIdentifier:[ZXSDChooseEmployerCell identifier]];
    
    [self.mainTable registerClass:ZXChooseCompanyCell.class forCellReuseIdentifier:ZXChooseCompanyCell.identifier];

}

#pragma mark - data handle -

- (void)companyCheckReqeust:(ZXSDCompanyModel*)model{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:model.companyName forKey:@"companyName"];
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_companyCheck parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        NSDictionary *dic = (NSDictionary*)response.originalContent;
        if (!IsValidDictionary(dic)) {
            [self showToastWithText:@"服务器异常，请稍后再试."];
            return;
        }
        
        ZXCompanyCheckModel *checkModel = [ZXCompanyCheckModel instanceWithDictionary:response.originalContent];
        
        if (checkModel.success) {
            [ZXSDCurrentUser currentUser].company = self.selectedCompany;
            
            SEL selector = @selector(gotoMainHome);
            if ([ZXSDCurrentUser currentUser].businessModel == ZXSDCooperationModelEmployerQuery) {
                selector = @selector(toConfirmUserInfoPage);
            }
            [self performSelector:selector withObject:nil afterDelay:.1];
        }
        else {
            
            if ([checkModel.code isEqualToString:@"ID_CARD_EXIST"]) {
                if (checkModel) {
                    [URLRouter routerUrlWithPath:kRouter_existNote extra:@{@"checkModel":checkModel}];
                }
            }
            else{
                if (IsValidString(checkModel.message)) {
                    [self showToastWithText:checkModel.message];
                }
            }
        }
    }];
    
}


#pragma mark - Action
- (void)backButtonClicked:(id)sender
{
    if (!self.isHome) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkEmployer
{
    if (!self.selectedCompany) {
        [self showToastWithText:@"请选择您的公司"];
        return;
    }
    
    ZXSDCompanyModel *model = self.selectedCompany;
    
    // 其他企业
    if ([model.companyRefId isEqualToString:@"0000"]) {
        SEL selector = self.isHome?@selector(toPreviousPage):@selector(gotoMainHome);
        [self performSelector:selector withObject:nil afterDelay:.1];
        // 选中其他企业, 进行标记
        NSString *userId = [ZXSDUserDefaultHelper readValueForKey:KEEPLOGINSTATUSUSERID];
        NSString *key = [NSString stringWithFormat:@"%@_%@", USER_INITIAL_COMPANY_OTHER, userId];
        [ZXSDUserDefaultHelper storeValueIntoUserDefault:@(YES) forKey:key];
        return;
    }
    
    [self companyCheckReqeust:model];
}

- (void)gotoMainHome
{
    if (self.isHome) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [ZXSDLoginService gotoMainHome:self.navigationController];
    }
}

- (void)toConfirmUserInfoPage
{
    ZXSDVerifyUserinfoController *vc = [ZXSDVerifyUserinfoController new];
    vc.company = self.selectedCompany;
    vc.forbidBack = !self.isHome;
    vc.fromLogin = !self.isHome;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)toPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chooseModels.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXChooseCompanyCell *cell = [ZXChooseCompanyCell instanceCell:tableView];

    [cell updateWithData:self.chooseModels[indexPath.section]];
    
    cell.delegate = self;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kThemeColorLine;
    return view;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#pragma mark - ZXChooseCompanyCellDelegate -

- (void)checkBtn:(UIButton*)btn item:(id)item{
    
    ZXCompanySelectionModel *model = (ZXCompanySelectionModel*)item;
    
    if (btn.selected) {
        return;
    }
    
    btn.selected = !btn.selected;
    model.selected = btn.selected;
    
    [self.chooseModels enumerateObjectsUsingBlock:^(ZXCompanySelectionModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![model.title isEqualToString:obj.title]) {
            obj.selected = !model.selected;
        }
    }];
    
    [self.mainTable reloadData];
    [self updateBottomButtonStatus];

}

- (void)itemSelectedAtIndex:(int)idx item:(ZXCompanySelectionModel*)model{
    
    [model.companys enumerateObjectsUsingBlock:^(ZXSDCompanyModel*  _Nonnull obj1, NSUInteger index, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj1.selecteStatus = !obj1.selecteStatus;
        }
        else{
            obj1.selecteStatus = NO;
        }
        

    }];
   
   [self.chooseModels replaceObjectAtIndex:1 withObject:model];
    [self.mainTable reloadData];
    
    [self updateBottomButtonStatus];

}

#pragma mark - help methods -
- (void)updateBottomButtonStatus{

    __block BOOL hasSelectCompany = NO;
    [self.chooseModels enumerateObjectsUsingBlock:^(ZXCompanySelectionModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            
            if (!IsValidArray(obj.companys)) {
                self.selectedCompany = self.otherCompany;
                hasSelectCompany = YES;
                *stop = YES;

            }
            else{
                [obj.companys enumerateObjectsUsingBlock:^(ZXSDCompanyModel*  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                    if (obj1.selecteStatus) {
                        self.selectedCompany = obj1;
                        
                        hasSelectCompany = YES;
                        *stop = YES;
                    }
                }];
            }
        }
    }];
    
    self.confirmButton.userInteractionEnabled = hasSelectCompany;
    if (hasSelectCompany) {
        [self.confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
    }
    else{
        [self.confirmButton setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:nil forState:UIControlStateNormal];
    }


}

#pragma mark - Getter

- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTable.backgroundColor = UIColor.whiteColor;
        _mainTable.showsVerticalScrollIndicator = NO;
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.rowHeight = UITableViewAutomaticDimension;
        _mainTable.estimatedRowHeight = 54;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedSectionFooterHeight = 0;
    }
    return _mainTable;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = TextColorDisable;
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [_confirmButton addTarget:self action:@selector(checkEmployer) forControlEvents:(UIControlEventTouchUpInside)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

@end
