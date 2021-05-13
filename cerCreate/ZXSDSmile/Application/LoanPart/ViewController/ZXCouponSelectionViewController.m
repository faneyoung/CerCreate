//
//  ZXCouponSelectionViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXCouponSelectionViewController.h"
#import "UITableView+help.h"

#import "ZXCouponListCell.h"
#import "ZXCouponListModel.h"

@interface ZXCouponSelectionViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZXCouponSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromHex(0xF7F9FB);
    self.tableView.backgroundColor = UIColorFromHex(0xF7F9FB);
    self.title = @"选择优惠";
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXCouponListCell.class),
    ]];
}

#pragma mark - views -
- (void)setupSubViews{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = FONT_PINGFANG_X(14);
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.backgroundColor = kThemeColorMain;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.bottom.inset(16+kBottomSafeAreaHeight);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(btn, 22, 1, kThemeColorMain);
    [btn addTarget:self action:@selector(useBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(btn.mas_top).inset(5);
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

#pragma mark - action methods -

- (void)backButtonClicked:(id)sender{
    [self useBtnClick];
}

- (void)useBtnClick{
    __block ZXCouponListModel *selCoupon = nil;
    [self.couponList enumerateObjectsUsingBlock:^(ZXCouponListModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.couponSelected) {
            selCoupon = obj;
            *stop = YES;
        }
    }];
    
    if (self.completionBlock) {
        self.completionBlock(selCoupon);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXCouponListCell *cell = [ZXCouponListCell instanceCell:tableView];
    cell.cellType = CouponListCellTypeSelect;
    [cell updateWithData:self.couponList[indexPath.row]];
    
    @weakify(self);
    cell.couponListCellNoteBlock = ^(int type) {
        @strongify(self);
        if (type == CouponListCellTypeDefault) {
            [self.tableView reloadData];
        }
    };
    return cell;
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
    
    ZXCouponListModel *selectedModel = self.couponList[indexPath.row];
    selectedModel.couponSelected = !selectedModel.couponSelected;
    
    [self.couponList enumerateObjectsUsingBlock:^(ZXCouponListModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (idx == indexPath.row) {

        }
        else{
            if (selectedModel.couponSelected) {
                obj.couponSelected = NO;
            }
        }

    }];
    
    [tableView reloadData];
    
}


@end
