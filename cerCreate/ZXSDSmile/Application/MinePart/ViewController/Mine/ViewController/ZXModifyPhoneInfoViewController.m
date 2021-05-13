//
//  ZXModifyPhoneInfoViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXModifyPhoneInfoViewController.h"
#import <IQKeyboardManager.h>
#import "UITableView+help.h"

//vc
#import "ZXSDLivingDetectionController.h"


//views
#import "ZXPhoneUpdateInputCell.h"


#import "EPNetworkManager.h"


@interface ZXModifyPhoneInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *oldPhoneNum;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *idcardNum;



@end

@implementation ZXModifyPhoneInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改绑定的手机号";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registerNibs: @[
        NSStringFromClass(ZXPhoneUpdateInputCell.class),
    ]];
    
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 56;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - data handle -

- (void)requstValidInfo{
    
//#warning --test--
//    [self gotoLivingDetectionVC];
//    return;
//#warning --test--

    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setSafeValue:self.oldPhoneNum forKey:@"oldPhone"];
    [params setSafeValue:self.name forKey:@"name"];
    [params setSafeValue:self.idcardNum forKey:@"idCardNo"];
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] postAPI:kPath_phoneUpdateValidPersonInfo parameters:params.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if ([self appErrorWithData:response.originalContent]) {
            
            NSString *respMsg = [response.originalContent stringObjectForKey:@"responseMsg"];
            if (IsValidString(respMsg)) {
                [self showToastWithText:respMsg];
            }
            
            return;
        }
        
        [self gotoLivingDetectionVC];
        
    }];
}

#pragma mark - action methods -
- (void)backButtonClicked:(nullable id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtnClicked{

    if (![self.oldPhoneNum validateStringIsPhoneNumberFormate]) {
        [self showToastWithText:@"请输入正确的旧手机号"];
        return;
    }
    
    if (self.name.length < 1) {
        [self showToastWithText:@"请输入您的姓名"];
        return;
    }
    
    if (![self.idcardNum validateStringIsIDCardFormate]) {
        [self showToastWithText:@"请输入正确的身份证号"];
        return;
    }
    
    [self requstValidInfo];

}

#pragma mark - help methods -
//前往人脸识别页面
- (void)gotoLivingDetectionVC
{
    ZXSDLivingDetectionController *viewController = [[ZXSDLivingDetectionController alloc] init];
    viewController.phone = self.phone;
    viewController.detectType = LivingDetectionTypePhoneUpdate;
    if (self.backViewController) {
        viewController.backViewController = self.backViewController;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXPhoneUpdateInputCell *cell = [ZXPhoneUpdateInputCell instanceCell:tableView];
    cell.type = indexPath.row;
    
    @weakify(self);
    cell.inputBlock = ^(NSString * _Nonnull str, PhoneUpdateType type) {
        @strongify(self);
        if (type == PhoneUpdateTypePhone) {
            self.oldPhoneNum = str;
        }
        else if(type == PhoneUpdateTypeName){
            self.name = str;
        }
        else if(type == PhoneUpdateTypeIdcard){
            self.idcardNum = str;
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 84;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return nil;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [tableView defaultHeaderFooterView];
    footView.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_PINGFANG_X_Medium(16);
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(40);
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(btn, 22, 0.1, UIColor.whiteColor);
    [btn setBackgroundImage:[UIImage  imageWithGradient:@[UIColorFromHex(0x00C35A),UIColorFromHex(0x00D663),] size:CGSizeMake(SCREEN_WIDTH()-2*20, 44) direction:UIImageGradientDirectionRightSlanted] forState:UIControlStateNormal];

    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
