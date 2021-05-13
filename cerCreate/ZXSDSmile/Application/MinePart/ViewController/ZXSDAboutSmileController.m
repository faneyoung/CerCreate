//
//  ZXSDAboutSmileController.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAboutSmileController.h"

@interface ZXSDAboutSmileController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *_aboutTableView;
    
    NSArray *_titleArray;
}

@end

@implementation ZXSDAboutSmileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableInteractivePopGesture = YES;
    
    self.title = @"关于";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_back") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    
    [self prepareDataConfigure];
    [self addUserInterfaceConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHOW_NAVIGATION_BAR_OF_NAVIGATION_CONTROLLER(self.navigationController);
    [self ZXSDNavgationBarConfigure];
}

- (void)prepareDataConfigure {
    _titleArray = @[@"用户协议",@"隐私协议",/*@"为薪朋友 App 评分"*/];
    
}

- (void)addUserInterfaceConfigure {
    /*
    UIImageView *headerBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 143 + NAVIBAR_HEIGHT())];
    headerBackView.userInteractionEnabled = YES;
    
    headerBackView.image = [ZXSDPublicClassMethod initImageFromColor:UICOLOR_FROM_HEX(0x00B050) Size:CGSizeMake(SCREEN_WIDTH(), SCREEN_HEIGHT() + 143)];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(5, STATUSBAR_HEIGHT(), 35, 44);
    [cancelButton setImage:UIIMAGE_FROM_NAME(@"smile_back_white") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH()/2 - 100, NAVIBAR_HEIGHT() - 33, 200, 22)];
    titleLabel.text = @"关于";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:19.0];
    [headerBackView addSubview:titleLabel];
    
    UIImageView *characterImageView = [[UIImageView alloc] initWithImage:UIIMAGE_FROM_NAME(@"smile_mine_character")];
    characterImageView.frame = CGRectMake(15, NAVIBAR_HEIGHT() + 44, SCREEN_WIDTH() - 30, 99);
    characterImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerBackView addSubview:characterImageView];

    [self.view addSubview:headerBackView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT() + 143 - 30, SCREEN_WIDTH(), SCREEN_HEIGHT() - NAVIBAR_HEIGHT() - 113)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(24.0, 24.0)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
    cornerRadiusLayer.frame = bottomView.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    bottomView.layer.mask = cornerRadiusLayer;
    [self.view addSubview:bottomView];*/
    
    _aboutTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _aboutTableView.backgroundColor = [UIColor whiteColor];
    _aboutTableView.scrollEnabled = NO;
    _aboutTableView.delegate = self;
    _aboutTableView.dataSource = self;
    _aboutTableView.showsVerticalScrollIndicator = NO;
    _aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_aboutTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _aboutTableView.separatorColor = UICOLOR_FROM_HEX(0xDDDDDD);
    [self.view addSubview:_aboutTableView];
    [_aboutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)cancelButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"aboutSmileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    cell.textLabel.textColor = UICOLOR_FROM_HEX(0x333333);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_mine_arrow"]];
    indicatorView.frame = CGRectMake(0, 0, 16, 16);
    cell.accessoryView = indicatorView;
//    if (indexPath.row == 0) {
//        [cell hideBottomLine];
//    } else {
        [cell showBottomLine];
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        return 70;
    }
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self jumpToUserAgreementController];
    } else if (indexPath.row == 1) {
        [self jumpToPrivacyAgreementController];
    } else if (indexPath.row == 2) {
        [self jumpToAppStoreReview];
    }
}

//跳转用户协议
- (void)jumpToUserAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,USER_SERVICE_URL];
    viewController.title = @"用户协议";
    
    [self.navigationController pushViewController:viewController animated:YES];
}

//查看隐私协议
- (void)jumpToPrivacyAgreementController {
    ZXSDWebViewController *viewController = [ZXSDWebViewController new];
    viewController.requestURL = [NSString stringWithFormat:@"%@%@",H5_URL,PRIVACY_AGREEMENT_URL];
    viewController.title = @"隐私协议";
    
    [self.navigationController pushViewController:viewController animated:YES];
}

//给 Smile 评分
- (void)jumpToAppStoreReview {
    NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id1517015114?action=write-review"]];
    if ([[UIApplication sharedApplication] canOpenURL:appReviewUrl]) {
        [[UIApplication sharedApplication] openURL:appReviewUrl];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
