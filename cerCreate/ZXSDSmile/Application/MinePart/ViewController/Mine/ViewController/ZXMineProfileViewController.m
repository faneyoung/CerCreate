//
//  ZXMineProfileViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMineProfileViewController.h"
#import "UITableView+help.h"

//vc
#import "ZXSDNecessaryCertFourthStepController.h"

//views
#import "ZXPersonalItemCell.h"

#import "ZXPersonalCenterModel.h"

@interface ZXMineProfileViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *personalItems;

@end

@implementation ZXMineProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.enableInteractivePopGesture = YES;
    
    [self.tableView registerNibs: @[
        NSStringFromClass(ZXPersonalItemCell.class),
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

- (NSArray *)personalItems{
    if (!_personalItems) {
        _personalItems = [ZXPersonalCenterModel personalProfileItems];
    }
    return _personalItems;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personalItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.personalItems[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXPersonalItemCell *cell = [ZXPersonalItemCell instanceCell:tableView];
    NSArray *rowItems = self.personalItems[indexPath.section];
    [cell updateWithData:rowItems[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [tableView defaultHeaderFooterView];
    view.backgroundColor = kThemeColorBg;
    return view;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *rowItems = self.personalItems[indexPath.section];
    ZXPersonalCenterModel *model = rowItems[indexPath.row];
    
//    if (model.needVerify) {
//        if (!self.statusModel.bankCardDone) {
//            [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
//            return;
//        }
//
//        if (!self.statusModel.jobInfoDone) {
//            ZXSDNecessaryCertFourthStepController *vc = [ZXSDNecessaryCertFourthStepController new];
//            vc.backViewController = self;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//    }
    
    [URLRouter routerUrlWithPath:model.action extra:nil];
}

@end
