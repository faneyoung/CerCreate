//
//  ZXAccountSecurityViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAccountSecurityViewController.h"
#import "UITableView+help.h"

#import "ZXAcountSecurityPhoneCell.h"
#import "ZXAccountSecurityItemCell.h"

#import "EPNetworkManager.h"
#import "ZXPersonalCenterModel.h"
#import "ZXAccountSecurityModel.h"
#import "ZXSDLoginService.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypePhone,
    SectionTypeSocialContact,
    SectionTypeAll
};

@interface ZXAccountSecurityViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *personalItems;
@property (nonatomic, assign) BOOL canModify;
@property (nonatomic, strong) NSString *modifymsg;

@property (nonatomic, strong) NSArray *accountItems;


@end

@implementation ZXAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账户安全";
    self.enableInteractivePopGesture = YES;

    [self.tableView registerNibs: @[
        NSStringFromClass(ZXAcountSecurityPhoneCell.class),
        NSStringFromClass(ZXAccountSecurityItemCell.class),
    ]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestPhoneUpdateInit];
    [self requestWXbindStatus];
}

#pragma mark - views -

- (void)setupSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 56;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

#pragma mark - data handle -
- (void)requestPhoneUpdateInit{

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] getAPI:kPath_phoneUpdateInit parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        LoadingManagerHidden();

        self.modifymsg = [(NSDictionary*)response.originalContent stringObjectForKey:@"responseMsg"];

        if (error) {
            [self handleRequestError:error];
            return;
        }
        
//        if ([self appErrorWithData:response.originalContent]) {
//            return;
//        }
        if (response.resultModel.code != 0) {
            self.modifymsg = response.resultModel.responseMsg;
            return;
        }
        
        self.canModify = YES;
        [self.tableView reloadData];
        
    }];
}

- (void)requestWXbindStatus{
    LoadingManagerShow();
    
    NSMutableDictionary *tmps = [NSMutableDictionary dictionaryWithCapacity:2];
    [tmps setSafeValue:@"WeChatApp" forKey:@"platform"];

    [[EPNetworkManager defaultManager] postAPI:kPath_queryWxBindStatus parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        LoadingManagerHidden();

        if (error) {
            [self handleRequestError:error];
            return;
        }

        if (response.resultModel.code != 0) {
            return;
        }
        
        
        BOOL needBind = [(NSDictionary*)response.originalContent boolValueForKey:@"data"];
        ZXAccountSecurityModel *model = self.accountItems.firstObject;
        model.status = needBind;
        [self.tableView reloadData];
        
    }];

}

- (void)requestWxBindWithWXAuth:(NSDictionary*)dic{
    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kPath_wxBind parameters:dic decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        LoadingManagerHidden();

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
        
        ToastShow(@"绑定成功");
        [self requestWXbindStatus];
    }];
}

- (void)requestUnbindweixin{
    LoadingManagerShow();
    NSMutableDictionary *tmps = [NSMutableDictionary dictionaryWithCapacity:1];
    [tmps setSafeValue:@"WeChatApp" forKey:@"platform"];

    [[EPNetworkManager defaultManager] postAPI:kPath_wxUnbind parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        LoadingManagerHidden();

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
        
        ToastShow(@"解绑成功");
        [self requestWXbindStatus];
    }];

}

- (NSArray *)accountItems{
    if (!_accountItems) {
        ZXAccountSecurityModel *model = [[ZXAccountSecurityModel alloc] init];
        
        _accountItems = model.societyAccounts;
    }
    
    return _accountItems;
}

- (NSArray *)personalItems{
    if (!_personalItems) {
        _personalItems = [ZXPersonalCenterModel personalSettingItems];
    }
    return _personalItems;
}



#pragma mark - action -
- (void)backButtonClicked:(nullable id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)bindAndUnbindActionWithModel:(ZXAccountSecurityModel*)model{
    if (!model.status) {//解绑
        [self requestUnbindweixin];
        return;
    }

    
    [ZXSDLoginService wxAuthComplete:^(NSDictionary * _Nonnull dic, NSError * _Nonnull error) {
        
        if (error) {
            NSString *errMsg = [error.userInfo stringObjectForKey:@"message"];
             ToastShow(errMsg);
            return;
        }
        
        if (!IsValidDictionary(dic)) {
            ToastShow(@"微信授权失败");
            return;
        }
        
        [self requestWxBindWithWXAuth:dic];
    }];

    
    
}


#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SectionTypeSocialContact) {
        return self.accountItems.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypePhone) {
        ZXAcountSecurityPhoneCell *cell = [ZXAcountSecurityPhoneCell instanceCell:tableView];
        [cell updateWithData:nil];
        cell.canModify = self.canModify;
        
        return cell;

    }
    else if(indexPath.section == SectionTypeSocialContact){
        ZXAccountSecurityItemCell *cell = [ZXAccountSecurityItemCell instanceCell:tableView];
        [cell updateWithData:self.accountItems[indexPath.row]];
        return cell;
    }
    
    
    return [tableView defaultReuseCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SectionTypeSocialContact) {
        return 44;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kThemeColorLine;
    
    if (section == SectionTypeSocialContact) {
        view.backgroundColor = UIColor.whiteColor;
        
        UILabel *seplab = [[UILabel alloc] init];
        seplab.backgroundColor = kThemeColorLine;
        [view addSubview:seplab];
        [seplab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.inset(0);
            make.height.mas_equalTo(8);
        }];
        
        UILabel *lab = [UILabel labelWithText:@"社交账号" textColor:TextColorTitle font:FONT_PINGFANG_X(14)];
        
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(seplab.mas_bottom).inset(16);
            make.left.inset(20);
            make.height.mas_equalTo(20);
        }];
    }

    return view;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SectionTypePhone) {
        NSMutableDictionary *params = @{}.mutableCopy;
        if (indexPath.row == 0) {
            [params setSafeValue:self.backViewController forKey:@"backViewController"];
            
            if (!self.canModify) {
                if (IsValidString(self.modifymsg)) {
                    [self showToastWithText:self.modifymsg];
                }
                return;
            }
        }
        
        [URLRouter routerUrlWithPath:kRouter_modifyPhone extra:params.copy];

    }
    else if(indexPath.section == SectionTypeSocialContact){
        
        ZXAccountSecurityModel *model = self.accountItems[indexPath.row];
        [self bindAndUnbindActionWithModel:model];
    }
    
    
}



@end
