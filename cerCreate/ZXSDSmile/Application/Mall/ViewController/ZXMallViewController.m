//
//  ZXMallViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallViewController.h"
#import "UICollectionView+help.h"

//views
#import "ZXMallTopBannerCell.h"
#import "ZXMallRechargeCell.h"

#import "ZXMallGoodsTitleView.h"
#import "ZXMallGoodsItemCell.h"
#import "ZXMallGoodsFooterView.h"

#import "EPNetworkManager+Home.h"
#import "ZXBannerModel.h"
#import "ZXGoodsModel.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeBanner,
    SectionTypeRecharge,
    SectionTypeGoods,
    SectionTypeAll
};

@interface ZXMallViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ZXHomeBannerModel *bannerModel;
@property (nonatomic, strong) ZXHomeBannerModel *rechargeModel;

@property (nonatomic, strong) NSArray *goodsList;
@property (nonatomic, strong) UIButton *orderBtn;


@end

@implementation ZXMallViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderCount) name:kNotificationRefreshOrderCount object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHideNavigationBar = YES;
    
    [self.collectionView registerClass:[ZXMallGoodsTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(ZXMallGoodsTitleView.class)];
    [self.collectionView registerClass:[ZXMallGoodsFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(ZXMallGoodsFooterView.class)];

    [self.collectionView registerNibs:@[
        NSStringFromClass(ZXMallTopBannerCell.class),
        NSStringFromClass(ZXMallRechargeCell.class),
        NSStringFromClass(ZXMallGoodsItemCell.class),
    ]];
    
//    [self testBtnAction:^(UIButton * _Nonnull btn) {
//        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationRefreshOrderCount object:nil];
//    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshAllData];
}

#pragma mark - views -
- (void)setupSubViews{
    self.view.backgroundColor = kThemeColorBg;
    
    UIView *customNavView = [[UIView alloc] init];
    customNavView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:customNavView];
    [customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:UIImageNamed(@"icon_mall_rightBarBtn") forState:UIControlStateNormal];
    [btn setImage:UIImageNamed(@"icon_mall_rightBarBtn_H") forState:UIControlStateSelected];
    [customNavView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.inset(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(54);
    }];
    [btn addTarget:self action:@selector(orderBtnClicked) forControlEvents: UIControlEventTouchUpInside];
    self.orderBtn = btn;
    
    UILabel *titleLab = [UILabel labelWithText:@"商城" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(22)];
    [customNavView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.centerY.mas_equalTo(btn);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customNavView.mas_bottom).inset(0);
        make.left.bottom.right.inset(0);
    }];
    
    
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH()-2*16, 144);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kThemeColorBg;
    }
    return _collectionView;
}

#pragma mark - data handle -

- (void)refreshAllData{

    [self requestMallTopBanner];
    [self requestGoodsList];
    
}

- (void)requestGoodsList{
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"dahan" forKey:@"channel"];
//    LoadingManagerShow();
    [EPNetworkManager.defaultManager getAPI:kPath_onSaleGoodsList parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
//        LoadingManagerHidden();
        if ([self handleError:error response:response]) {
            return;
        }
        
        NSArray *goodsModels = [ZXGoodsModel modelsWithData:response.resultModel.data];
        
        if (IsValidArray(goodsModels)) {
            if (goodsModels.count%2 != 0) {
                ZXGoodsModel *blankModel = [[ZXGoodsModel alloc] init];
                blankModel.showBlankView = YES;
                NSMutableArray *tmps = [NSMutableArray arrayWithArray:goodsModels];
                [tmps addObject:blankModel];
                goodsModels = tmps.copy;
            }
        }
        
        self.goodsList = goodsModels;
        
        [self.collectionView reloadData];
    }];
}


- (void)requestMallTopBanner{
    [EPNetworkManager.defaultManager getAPI:kPath_mallBanner parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        
        if (response.resultModel.code != 0) {
            return;
        }
        
       __block NSDictionary *bannerDic = nil;
       __block NSDictionary *rechargeDic = nil;
        [((NSDictionary*)response.resultModel.data) enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (IsValidString(key) && IsValidArray(obj)) {
                
                if ([key isEqualToString:@"bannerList"]) {
                    bannerDic = @{key:obj};

                }
                else if([key isEqualToString:@"virtualProductList"]){
                    rechargeDic = @{key:obj};
                }

            }
        }];
        
        self.bannerModel = [ZXHomeBannerModel instanceWithDictionary:bannerDic];
        self.rechargeModel = [ZXHomeBannerModel instanceWithDictionary:rechargeDic];
        [self.collectionView reloadData];
        
    }];
}

#pragma mark - noti -

- (void)refreshOrderCount{
    self.orderBtn.selected = YES;
    
}

#pragma mark - action methods -
- (void)orderBtnClicked{
    self.orderBtn.selected = NO;
    [URLRouter routerUrlWithPath:kRouter_orderPage extra:nil];
}

#pragma mark - UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SectionTypeAll;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == SectionTypeBanner) {
        return 1;
    }
    else if(section == SectionTypeRecharge){
        
        if (!self.rechargeModel ||
            !IsValidArray(self.rechargeModel.list)) {
            return 0;
        }
        return 1;
    }
    else if(section == SectionTypeGoods){
        
        return self.goodsList.count;
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == SectionTypeBanner) {
        ZXMallTopBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ZXMallTopBannerCell.class) forIndexPath:indexPath];
        [cell updateWithData:self.bannerModel];
        return cell;
    }
    else if(indexPath.section == SectionTypeRecharge){
        ZXMallRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ZXMallRechargeCell.class) forIndexPath:indexPath];
        [cell updateWithData:self.rechargeModel];
        return cell;
    }
    else if(indexPath.section == SectionTypeGoods){
        ZXMallGoodsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ZXMallGoodsItemCell.class) forIndexPath:indexPath];
        
        [cell updateWithData:self.goodsList[indexPath.item]];
        return cell;
    }
    
    return [[UICollectionViewCell alloc] init];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == SectionTypeGoods) {
        return CGSizeMake(SCREEN_WIDTH(), 55);
        
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == SectionTypeGoods) {
        return CGSizeMake(SCREEN_WIDTH(), 162);
    }
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeGoods) {
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            ZXMallGoodsFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(ZXMallGoodsFooterView.class) forIndexPath:indexPath];
            return footer;
        }
        ZXMallGoodsTitleView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(ZXMallGoodsTitleView.class) forIndexPath:indexPath];
        return view;

    }
    
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeGoods) {
        
       BOOL left = indexPath.item%2 == 0;
        ((ZXMallGoodsItemCell*)cell).isLeftItem = left;
        
        
        [self shadowSettingWithCell:cell indexPath:indexPath];
        
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionTypeBanner) {
        return CGSizeMake(SCREEN_WIDTH(),SCREEN_WIDTH()*280/375);
    }
    else if(indexPath.section == SectionTypeRecharge){
        return CGSizeMake(SCREEN_WIDTH(), 209);
    }
    else if(indexPath.section == SectionTypeGoods){
        CGFloat margin = 16;
        CGFloat space = 0;
        int itemsInRow = 2;
        
        CGFloat width = (SCREEN_WIDTH()-(itemsInRow-1)*space-2*margin)/itemsInRow;
        CGFloat height = 100 + (SCREEN_WIDTH()-5*margin)/2;
        return CGSizeMake(width, height);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == SectionTypeGoods) {
        return UIEdgeInsetsMake(0, 16, 0, 16);
    }

    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ZXGoodsModel *goods = self.goodsList[indexPath.item];
    if (goods.showBlankView) {
        return;
    }
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@(goods.hideTitle) forKey:@"isHideTitle"];
    [URLRouter routerUrlWithPath:goods.targetUrl extra:tmps.copy];
}

#pragma mark - shadow setting -
- (void)shadowSettingWithCell:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    // 圆角角度
    CGFloat radius = 4.f;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.whiteColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [self.collectionView numberOfItemsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    
    normalBgView.clipsToBounds = YES;
    if (indexPath.row == rowNum - 2) {
        normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, 0));
        CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
        // 每组最后一行（添加左下和右下的圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
    }
    else if (indexPath.row == rowNum - 1) {
        normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 0, 0));
        CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
        // 每组最后一行（添加左下和右下的圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    }
    else {
        // 每组不是首位的行不设置圆角
        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    }
    
    // 阴影
    normalLayer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    normalLayer.shadowOpacity = 0.2;
    normalLayer.shadowOffset = CGSizeMake(0, 5);
    normalLayer.path = bezierPath.CGPath;
    normalLayer.shadowPath = bezierPath.CGPath;
    normalLayer.cornerRadius = 4;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = UIColor.whiteColor.CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
    
    // 替换cell点击效果
    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
    selectLayer.fillColor = UIColor.whiteColor.CGColor;
    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
    selectBgView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectBgView;

}

@end
