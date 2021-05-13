//
//  ZXScreenshotDesViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/3.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScreenshotDesViewController.h"
#import "UITableView+help.h"

#import "ZXScreenshotDesCell.h"
#import "ZXHomeLoanNoteCell.h"

#import "ZXScoreUploadStepDes.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeNote,
    SectionTypeDes,
    SectionTypeAll
};

@interface ZXScreenshotDesViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSArray *stepDesModels;

@end

@implementation ZXScreenshotDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableInteractivePopGesture = YES;
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXHomeLoanNoteCell.class),
        NSStringFromClass(ZXScreenshotDesCell.class),
    ]];
    
    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    
}

#pragma mark - views -

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        UIButton *btn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(14) title:@"我知道了，开始截屏" textColor:UIColor.whiteColor];
        [btn setBackgroundImage:GradientImageThemeBlue() forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(30);
            make.bottom.inset(10+kBottomSafeAreaHeight);
            make.height.mas_equalTo(44);
        }];
        ViewBorderRadius(btn, 22.0, 0.01, UIColor.whiteColor);
        _confirmBtn = btn;
    }
    return _confirmBtn;
}

- (void)setupSubViews{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(self.confirmBtn.mas_top).inset(5);
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
        _tableView.estimatedRowHeight = 158;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        
    }
    return _tableView;
}

#pragma mark - data handle -
- (void)setType:(NSString *)type{
    _type = type;
    
    ZXScoreUploadStepDes *stepDes = [[ZXScoreUploadStepDes alloc] init];
    if ([type rangeOfString:@"Wechat"].location != NSNotFound) {
        stepDes.desType = 1;
        self.title = @"微信支付分截屏上传";
        [self.confirmBtn setBackgroundImage:GradientImageThemeMain() forState:UIControlStateNormal];
    }
    else{
        stepDes.desType = 0;
        self.title = @"芝麻信用分截屏上传";
        [self.confirmBtn setBackgroundImage:GradientImageThemeBlue() forState:UIControlStateNormal];

    }
    
    self.stepDesModels = stepDes.stepDesModels;
    [self.tableView reloadData];
}

- (NSString*)desNote{

    NSString *note = @"注意：请保证您的支付宝在登陆状态，如果自动录屏并截屏的图片有广告文案等的遮挡，可以多次尝试截屏上传直到成功哦～";
    if ([self.type rangeOfString:@"Wechat"].location != NSNotFound) {
        note = @"注意：请保证您的微信在登陆状态，并且已授权开通微信支付分功能，如果自动录屏并截屏的图片有广告文案等的遮挡，可以多次尝试截屏上传直到成功哦～";
    }
    
    return note;
}

#pragma mark - action methods -

- (void)confirmBtnClick{
    if (self.desVCConfirmBlock) {
        self.desVCConfirmBlock();
    }

    [self.navigationController popViewControllerAnimated:NO];
    
}

- (BOOL)shouldShowTips{
    
    if([self.type rangeOfString:@"Wechat"].location != NSNotFound){
        if ([ZXSDCurrentUser currentUser].userHideScoreUploadNoteWX) {
            return NO;
        }
    }
    else{
        if ([ZXSDCurrentUser currentUser].userHideScoreUploadNoteAli) {
            return NO;
        }
    }
    return YES;
}

- (void)hidTipItemView{
    
    if([self.type rangeOfString:@"Wechat"].location != NSNotFound){
        [ZXSDCurrentUser currentUser].userHideScoreUploadNoteWX = YES;
    }
    else{
        [ZXSDCurrentUser currentUser].userHideScoreUploadNoteAli = YES;
    }
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SectionTypeNote) {
        if (![self shouldShowTips]) {
            return 0;
        }

        return 1;
    }
    return self.stepDesModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeNote) {
        ZXHomeLoanNoteCell *cell = [ZXHomeLoanNoteCell instanceCell:tableView];
        [cell updateWithData:[self desNote]];
        cell.cancelNoteBlock = ^{
            [self hidTipItemView];
            [self.tableView reloadData];
        };
        return cell;
    }
    
    ZXScreenshotDesCell *cell = [ZXScreenshotDesCell instanceCell:tableView];
    [cell updateWithData:self.stepDesModels[indexPath.row]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeNote) {
        return UITableViewAutomaticDimension;
    }
    ZXScoreUploadStepDes *desModel = self.stepDesModels[indexPath.row];
    return desModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}



@end
