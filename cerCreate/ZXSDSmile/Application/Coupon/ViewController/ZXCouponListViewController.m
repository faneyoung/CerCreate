//
//  ZXCouponListViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXCouponListViewController.h"
#import "UITableView+help.h"
#import "ZXCouponListCell.h"
#import "EPNetworkManager.h"
#import "ZXCouponListModel.h"

#define kTableViewHeaderHeight 44

@interface ZXCouponListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *couponItems;


@end

@implementation ZXCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromHex(0xF7F9FB);
    self.title = @"优惠券";
    
}

#pragma mark - views -
- (void)setupSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    self.tableView.showPlaceholdWhenLoad = NO;
    self.tableView.placeholderView = [self.tableView defaultPlaceholdViewWithMsg:@"暂无优惠券"];
    self.tableView.showPlaceholdWhenLoad = NO;
    
    @weakify(self);
    [self.tableView addHeaderRefreshingBlock:^{
        @strongify(self);
        [self requestCouponListWithType:self.counponType showLoading:NO];
        
    }];

    [self.tableView registerNibs:@[
    
        NSStringFromClass(ZXCouponListCell.class),
        
    ]];
    
    [self requestCouponListWithType:self.counponType showLoading:YES];

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromHex(0xF7F9FB);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 158;
        
    }
    return _tableView;
}

#pragma mark - data handle -
- (void)requestCouponListWithType:(CouponListPageType)type showLoading:(BOOL)loading{
    if (loading) {
        LoadingManagerShow();
    }
    
    type = type < 1 ? 1 : type;
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:[NSString stringWithFormat:@"0%d",(int)type] forKey:@"status"];
    [tmps setSafeValue:@"all" forKey:@"type"];

    
    [[EPNetworkManager defaultManager] postAPI:kCouponListPath parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_safe_async_main(^{
            LoadingManagerHidden();
            [self.tableView endHeaderFooterAnimation];
        });
        
//#warning --test--
//        self.couponItems = [ZXCouponListModel testModels];
//        [self.tableView reloadData];
//        return;
//#warning --test--

        
        if (error) {
            return;
        }
        
        if (response.resultModel.code != 0) {
            return;
        }
        
        self.couponItems = [ZXCouponListModel modelsWithData:response.resultModel.data];
        [self.tableView reloadData];

    }];
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXCouponListCell *cell = [ZXCouponListCell instanceCell:tableView];

    [cell updateWithData:self.couponItems[indexPath.row]];
    @weakify(self);
    cell.couponListCellNoteBlock = ^(int type) {
        @strongify(self);
        if (type == CouponListCellTypeDefault) {
            [self.tableView reloadData];
        }
    };
    cell.couponListCellUseBlock = ^(id  _Nonnull data) {
        @strongify(self);

        [self.navigationController popToRootViewControllerAnimated:NO];
        [URLRouter routeToMainPageTab];

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
    
}

#pragma mark - JXCategoryListContentViewDelegate -


// 返回列表视图
// 如果列表是 VC，就返回 VC.view
// 如果列表是 View，就返回 View 自己
- (UIView *)listView {
    return self.view;
}

@end
