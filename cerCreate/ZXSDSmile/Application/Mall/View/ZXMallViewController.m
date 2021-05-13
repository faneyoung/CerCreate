//
//  ZXMallViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallViewController.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeBanner,
    SectionTypeRecharge,
    SectionTypeGoods,
    SectionTypeAll
};

@interface ZXMallViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZXMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHideNavigationBar = YES;
    
}

#pragma mark - views -
- (void)setupSubViews{
    self.view.backgroundColor = kThemeColorBg;
    
    UIView *customNavView = [[UIView alloc] init];
    customNavView.backgroundColor = kThemeColorBg;
    [self.view addSubview:customNavView];
    [customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
    UIButton *btn = [UIButton buttonWithNormalImage:UIImageNamed(@"icon_mall_rightBarBtn") highlightedImage:UIImageNamed(@"icon_mall_rightBarBtn")];
    [customNavView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.inset(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(54);
    }];
    
    UILabel *titleLab = [UILabel labelWithText:@"商场" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(22)];
    [customNavView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(16);
        make.centerY.mas_equalTo(btn);
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
        
        //_collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kThemeColorBg;
    }
    return _collectionView;
}


#pragma mark - UICollectionDelegate
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    WLSearchCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[WLSearchCollectionHeaderView CellReuseIdentifier] forIndexPath:indexPath];
//    view.baseDelegate = self;
//    view.indexPath = indexPath;
//    [view updateViewWithModel:self.types[indexPath.section]];
//    return view;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(self.view.width, CGFloatScale(section?51:44));
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionTypeBanner) {
        return CGSizeMake(SCREEN_WIDTH()-2*16, 272);
    }
    else if(indexPath.section == SectionTypeRecharge){
        return CGSizeMake(SCREEN_WIDTH()-2*16, 201);
    }
    else if(indexPath.section == SectionTypeGoods){
        CGFloat margin = 16;
        CGFloat space = 16;
        int itemsInRow = 2;
        return CGSizeMake((SCREEN_WIDTH()-4*16-(itemsInRow-1)*space)/itemsInRow, 248);
    }
    
    return CGSizeZero;

//    WLSearchType type = [[self.types objectAtIndex:indexPath.section] integerValue];
//    if (type == WLSearchTypeRoom) {
//        return [WLLiveRoomCollectionViewCell ItemSize];
//    }else if (type == WLSearchTypeVideo) {
//        return [WLAppraisalVideoViewCell ItemSize];
//    }
//    else if (type == WLSearchTypeCommodity) {
//        return [WLAppraisalVideoViewCell ItemSize];
//    }
//    else if (type == WLSearchTypeAnchor) {
//        return [WLSearchAnchorViewCell ItemSize];
//    }
//    else if (type == WLSearchTypeStore) {
//        return [WLSearchStoreCell ItemSize];
//    }
//    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    WLSearchType type = [[self.types objectAtIndex:section] integerValue];
//    if (type == WLSearchTypeRoom) {
//        return [WLLiveRoomCollectionViewCell ItemInsets];
//    }else if (type == WLSearchTypeVideo) {
//        return [WLAppraisalVideoViewCell ItemInsets];
//    }
//    else if (type == WLSearchTypeCommodity) {
//        return [WLAppraisalVideoViewCell ItemInsets];
//    }
//    else if (type == WLSearchTypeAnchor) {
//        return [WLSearchAnchorViewCell ItemInsets];
//    }
//    else if (type == WLSearchTypeStore) {
//        return [WLSearchStoreCell ItemInsets];
//    }

    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    WLSearchType type = [[self.types objectAtIndex:section] integerValue];
//    if (type == WLSearchTypeRoom) {
//        return [WLLiveRoomCollectionViewCell ItemMinLineSpacing];
//    }else if (type == WLSearchTypeVideo) {
//        return [WLAppraisalVideoViewCell ItemMinLineSpacing];
//    }else if (type == WLSearchTypeAnchor) {
//        return [WLSearchAnchorViewCell ItemMinLineSpacing];
//    }
//    else if (type == WLSearchTypeCommodity) {
//        return [WLAppraisalVideoViewCell ItemMinLineSpacing];
//    }else if (type == WLSearchTypeStore) {
//        return [WLSearchAnchorViewCell ItemMinLineSpacing];
//    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    WLSearchType type = [[self.types objectAtIndex:section] integerValue];
//    if (type == WLSearchTypeRoom) {
//        return [WLLiveRoomCollectionViewCell ItemMinInterSpacing];
//    }else if (type == WLSearchTypeVideo) {
//        return [WLAppraisalVideoViewCell ItemMinInterSpacing];
//    }else if (type == WLSearchTypeAnchor) {
//        return [WLSearchAnchorViewCell ItemMinInterSpacing];
//    }
//    else if (type == WLSearchTypeStore) {
//        return [WLSearchAnchorViewCell ItemMinInterSpacing];
//    }
//    else if (type == WLSearchTypeCommodity) {
//        return [WLLiveRoomCollectionViewCell ItemMinInterSpacing];
//    }
    return 0;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SectionTypeAll;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == SectionTypeBanner) {
        return 1;
    }
    else if(section == SectionTypeRecharge){
        return 1;
    }
    else if(section == SectionTypeGoods){
        return 1;
    }
    
    return 0;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BaseCollectionViewCell *cell = nil;
    
    NSArray *datas = [self.datas objectAtIndex:indexPath.section];

    WLSearchType type = [[self.types objectAtIndex:indexPath.section] integerValue];
    if (type == WLSearchTypeRoom) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLLiveRoomCollectionViewCell CellReuseIdentifier] forIndexPath:indexPath];
    }else if (type == WLSearchTypeVideo) {
        id data = datas[indexPath.row];
        if ([data isKindOfClass:AppraisalVideoModel.class]) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLAppraisalVideoViewCell CellReuseIdentifier] forIndexPath:indexPath];
        }
        else if ([data isKindOfClass:LiveRoomModel.class]){
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLLiveRoomCollectionViewCell CellReuseIdentifier] forIndexPath:indexPath];
        }
    }else if (type == WLSearchTypeAnchor) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLSearchAnchorViewCell CellReuseIdentifier] forIndexPath:indexPath];
    }
    else if (type == WLSearchTypeCommodity) {
        WLAuctionModel * data = datas[indexPath.row];
        if (data.type.intValue == 4) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLFixedPriceGoodsCell CellReuseIdentifier] forIndexPath:indexPath];
        }
        else{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLAuctionListCell CellReuseIdentifier] forIndexPath:indexPath];
        }
    }
    else if (type == WLSearchTypeStore) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WLSearchStoreCell CellReuseIdentifier] forIndexPath:indexPath];
    }
    
    cell.indexPath = indexPath;
    cell.baseDelegate = self;
    [cell updateViewWithModel:datas[indexPath.row]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSArray *datas = [self.datas objectAtIndex:indexPath.section];
    WLSearchType type = [[self.types objectAtIndex:indexPath.section] integerValue];
    if (type == WLSearchTypeRoom) {
        LiveRoomModel *model = [datas objectAtIndex:indexPath.row];
        [URLRouter routerUrlWithPath:kURLRouter_LiveRoom extra:@{@"roomId":@(model.roomId),@"roomModel":model}];
    }
    else if (type == WLSearchTypeVideo) {
        id model = [datas objectAtIndex:indexPath.row];
        if ([model isKindOfClass:AppraisalVideoModel.class]) {
            AppraisalVideoModel *videoModel = (AppraisalVideoModel*)model;
            [URLRouter routerUrlWithPath:kURLRouter_AppraisalVideo params:@{@"videoId":@(videoModel.videoData.videoId)}];
        }
        else if ([model isKindOfClass:LiveRoomModel.class]){
            LiveRoomModel *roomModel = (LiveRoomModel*)model;
            //            [URLRouter routerUrlWithPath:kURLRouter_LiveRoom extra:@{@"roomId":@(roomModel.roomId),@"roomModel":roomModel}];
            [MediaAuthHelper checkMediaAuth:@[AVMediaTypeAudio,AVMediaTypeVideo] completeBlock:^{
                
                //        [URLRouter routerUrlWithPath:kURLRouter_LiveRoom extra:@{@"roomId":@(model.roomId),@"roomModel":model}];
                if (![AccountManager showLoginPageIfNeeded]) {
                    WLLiveRoomController *liveRoomVC = [[WLLiveRoomController alloc] init];
                    liveRoomVC.roomId = roomModel.roomId;
                    liveRoomVC.roomModel = model;
                    liveRoomVC.hidesBottomBarWhenPushed = YES;
                    [liveRoomVC updateLiveRoomView:@[roomModel] index:0];
                    [self.navigationController pushViewController:liveRoomVC animated:YES];
                    
                }
            }];
            
        }
    }
    else if (type == WLSearchTypeAnchor) {
        UserModel *model = [datas objectAtIndex:indexPath.row];
        if (model.nowRole == UserRoleAnchor) {
            [URLRouter routerUrlWithPath:kURLRouter_LiveAnchor params:@{@"userId":@(model.uid)}];
        }else if (model.nowRole == UserRoleAppraiser){
            [URLRouter routerUrlWithPath:kURLRouter_Appraiser params:@{@"userId":@(model.uid)}];
        }
    }
    else if (type == WLSearchTypeCommodity){
        WLAuctionModel *auction = [datas objectAtIndex:indexPath.item];
        
        [URLRouter routerUrlWithPath:kURLRouter_AuctionDetail extra:@{@"auction":auction}];
    }
    else if (type == WLSearchTypeStore){
        WLAuctionStoreInfo *model = [datas objectAtIndex:indexPath.row];

        if (!IsValidString(model.merchantId)) {
            return;
        }
        [URLRouter routerUrlWithPath:kURLRouter_AuctionShop extra:@{@"merchantId":model.merchantId}];

    }
}

@end
