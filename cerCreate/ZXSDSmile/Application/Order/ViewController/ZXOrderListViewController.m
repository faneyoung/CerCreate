//
//  ZXOrderListViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXOrderListViewController.h"
#import "UITableView+help.h"

//view
#import "CoverBackgroundView.h"
#import "ZXOrderListCell.h"

#import "EPNetworkManager.h"
#import "ZXOrderListModel.h"

static int kCategoryTitleHeigth = 44;

@interface ZXOrderListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;

@end


@implementation ZXOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"我的订单";
//    [self testBtnAction:^(UIButton * _Nonnull btn) {
//        [self orderToPayAlertViewWithOrder:nil];
//    }];
}

#pragma mark - views -
- (void)setupSubViews{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];

    self.tableView.showPlaceholdWhenLoad = NO;
    self.tableView.placeholderImage = UIImageNamed(@"icon_order_none");
    self.tableView.placeholderView = [self.tableView defaultPlaceholdViewWithMsg:@"您还没有订单"];
    self.tableView.showPlaceholdWhenLoad = NO;
    self.tableView.centery = -kCategoryTitleHeigth;

    @weakify(self);
    [self.tableView addHeaderRefreshingBlock:^{
        @strongify(self);
        [self requestCouponListWithType:self.pageType showLoading:NO];
        
    }];

    [self.tableView registerNibs:@[
    
        NSStringFromClass(ZXOrderListCell.class),
        
    ]];
    
    [self requestCouponListWithType:self.pageType showLoading:YES];

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kThemeColorBg;
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
- (void)requestCouponListWithType:(OrderPageType)type showLoading:(BOOL)loading{
    if (loading) {
        LoadingManagerShow();
    }
    
    NSString *typeStr = nil;
    NSMutableDictionary *tmps = @{}.mutableCopy;
    if (type == OrderPageTypeToPay) {//待支付
        typeStr = @"0";
    }
    else if(type == OrderPageTypeFinished){//已完成
        typeStr = @"1";
    }
    [tmps setSafeValue:typeStr forKey:@"status"];

    
    [[EPNetworkManager defaultManager] postAPI:kPath_orderList parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_safe_async_main(^{
            LoadingManagerHidden();
            [self.tableView endHeaderFooterAnimation];
        });
        
//#warning --test--
//        self.items = [ZXOrderListModel mockItems];
//        [self.tableView reloadData];
//        return;
//#warning --test--

        
        if ([self handleError:error response:response]) {
            return;
        }
        
        self.items = [ZXOrderListModel modelsWithData:response.resultModel.data];
        [self.tableView reloadData];

    }];
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXOrderListCell *cell = [ZXOrderListCell instanceCell:tableView];
    ZXOrderListModel *order = self.items[indexPath.row];
    [cell updateWithData:order];
    
    cell.orderBtnBlock = ^(OrderBtnType actionType) {
        
        if (actionType == OrderBtnTypeDetail) {
            if ([order.channel isEqualToString:@"fulu"]) {
                [self orderToPayAlertViewWithOrder:order];
                return;
            }
        }
        else if(actionType == OrderBtnTypeToPay){
            [URLRouter routerUrlWithPath:order.cashierUrl extra:@{}];
            return;
        }
        
        [URLRouter routerUrlWithPath:order.orderDetailUrl extra:@{}];
    };
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [tableView defaultHeaderFooterView];
    headerView.backgroundColor = kThemeColorBg;
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    ZXOrderListModel *order = self.items[indexPath.row];
//
//    [URLRouter routerUrlWithPath:order.targetUrl extra:nil];
}

#pragma mark - help metthods -
- (void)orderToPayAlertViewWithOrder:(ZXOrderListModel*)order{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = UIColor.whiteColor;
    ViewBorderRadius(contentView, 12, 0.01, UIColor.whiteColor);
    
    UIView *titleView = [[UIView alloc] init];
    [contentView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithNormalImage:UIImageNamed(@"icon_order_toPayCancel") highlightedImage:UIImageNamed(@"icon_order_toPayCancel")];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.inset(0);
        make.width.mas_equalTo(66);
    }];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [UILabel labelWithText:@"订单信息" textColor:TextColorTitle font:FONT_PINGFANG_X(17)];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UILabel *sepLab = [[UILabel alloc] init];
    sepLab.backgroundColor = UIColorFromHex(0xFCFCFC);
    [titleView addSubview:sepLab];
    [sepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(2);
    }];
    
    UIView *goodsView = [[UIView alloc] init];
    [contentView addSubview:goodsView];
    [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom);
        make.left.right.inset(0);
        make.height.mas_equalTo(90);
    }];
    
    ZXGoodsModel *goods = order.goodsList.firstObject;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    ViewBorderRadius(imgView, 4, 0.01, UIColor.whiteColor);
    imgView.backgroundColor = kThemeColorBg;
    [imgView setImgWithUrl:GetString(goods.showMages)];
    [goodsView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(10);
        make.left.inset(17);
        make.width.height.mas_equalTo(63);
    }];
    
    UILabel *nameLab = [UILabel labelWithText:GetString(goods.commodityName) textColor:TextColor333333 font:FONT_PINGFANG_X(15)];
    nameLab.numberOfLines = 2;
    [goodsView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(10);
        make.left.mas_equalTo(imgView.mas_right).inset(15);
        make.right.inset(12);
    }];
    
    UILabel *priceLab = [UILabel labelWithText:[NSString stringWithFormat:@"￥%@",GetStrDefault(goods.showAmount, @"0.0")] textColor:kThemeColorMain font:FONT_PINGFANG_X_Medium(17)];
    [goodsView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLab);
        make.bottom.inset(15);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *goodsSepLab = [[UILabel alloc] init];
    goodsSepLab.backgroundColor = UIColorFromHex(0xFCFCFC);
    [goodsView addSubview:goodsSepLab];
    [goodsSepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(9);
    }];
    
    UIView *orderView = [[UIView alloc] init];
    [contentView addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodsView.mas_bottom);
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(100);
    }];
    
    
    NSArray *titles = @[
        @"订单编号：",
        @"订单创建时间：",
        /*@"支付方式：",*/
    ];
    
    NSArray *values = @[
        GetStrDefault(order.refId, @" "),
        GetStrDefault(order.formatterTime, @" "),
        /*GetStrDefault(order.bankNo, @" "),*/
    ];
    

    CGFloat vSpace = 15.0;
    CGFloat itemHeight = 13.0;
    __block UIView *lastView = nil;
    [titles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *orderTitlelab = [UILabel labelWithText:obj textColor:TextColor333333 font:FONT_PINGFANG_X(13)];
        [orderView addSubview:orderTitlelab];
        [orderTitlelab mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.inset(idx*(vSpace+itemHeight)+vSpace);
            make.left.inset(17);
            make.height.mas_equalTo(itemHeight);
        }];
        
        UILabel *valuelab = [UILabel labelWithText:values[idx] textColor:TextColor333333 font:FONT_PINGFANG_X(13)];
        [orderView addSubview:valuelab];
        [valuelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(orderTitlelab);
            make.right.inset(12);
            make.height.mas_equalTo(orderTitlelab);
        }];

        if (idx == values.count-1) {
            lastView = orderTitlelab;
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [imgView sd_setImageWithURL:GetString(order.bankIcon).URLByCheckCharacter];
            [orderView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(valuelab);
                make.right.mas_equalTo(valuelab.mas_left).inset(0);
                make.width.height.mas_equalTo(24);
            }];
        }

    }];
    
    UILabel *statusLab = [UILabel labelWithText:GetString(order.statusStr) textColor:kThemeColorMain font:FONT_PINGFANG_X(11)];
    [orderView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastView.mas_bottom).inset(13);
        make.right.inset(12);
        make.height.mas_equalTo(11);
    }];
    
    
    CGFloat width = (SCREEN_WIDTH()-40.0)*296/(375-40.0);
//    CGFloat margin = (SCREEN_WIDTH()-width)/2.0;

    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:contentView mode:CoverViewShowModeCenter viewMake:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.center.offset(0);
    }];
    cover.bgViewUserEnable = NO;
    
    
}


#pragma mark - JXCategoryListContentViewDelegate -


// 返回列表视图
// 如果列表是 VC，就返回 VC.view
// 如果列表是 View，就返回 View 自己
- (UIView *)listView {
    return self.view;
}


@end
