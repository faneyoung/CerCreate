//
//  ZXOrderViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXOrderViewController.h"
#import <JXCategoryView.h>

//vc
#import "ZXOrderListViewController.h"

@interface ZXOrderViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) NSArray *cateTitles;

@end

@implementation ZXOrderViewController

static int CategoryTitleHeigth = 44;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.showNavBottomSepLine = YES;
    
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(CategoryTitleHeigth);
    }];
    
    
    self.categoryView.titles = self.cateTitles;
    
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(CategoryTitleHeigth);
        make.left.bottom.right.inset(0);
    }];
    // 关联到 categoryView
    self.categoryView.listContainer = self.listContainerView;

        

}

#pragma mark - getter -

- (NSArray *)cateTitles{
    if (!_cateTitles) {
        _cateTitles = @[@"全部", @"待支付", @"已完成"];
    }
    return _cateTitles;
}

- (JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        JXCategoryTitleView  *pagerCategoryView = [[JXCategoryTitleView alloc] init];
        pagerCategoryView.backgroundColor = UIColor.whiteColor;
        pagerCategoryView.titleSelectedFont = FONT_PINGFANG_X_Medium(16);
        pagerCategoryView.titleFont = FONT_PINGFANG_X(14);
//        pagerCategoryView.titleColor = TextColor333333;
//        pagerCategoryView.titleSelectedColor = kThemeColorMain;
        pagerCategoryView.titleColor = TextColorTitle;
        pagerCategoryView.titleSelectedColor = TextColorSubTitle;
        pagerCategoryView.titleColorGradientEnabled = YES;

        CGFloat left = 20;
        CGFloat right = 20;
        CGFloat space = 10;
        pagerCategoryView.contentEdgeInsetLeft = 20;
        pagerCategoryView.contentEdgeInsetRight = 20;
        pagerCategoryView.cellSpacing = 10;
//        pagerCategoryView.averageCellSpacingEnabled = YES;
//        pagerCategoryView.cellWidthZoomEnabled = YES;
        pagerCategoryView.cellWidth = (SCREEN_WIDTH()-left-right-space*(self.cateTitles.count-1))/self.cateTitles.count;
        
        JXCategoryIndicatorLineView *indicatorLineView = [[JXCategoryIndicatorLineView alloc] init];
        indicatorLineView.indicatorColor = kThemeColorMain;
        indicatorLineView.indicatorHeight = 3;
        indicatorLineView.scrollStyle = JXCategoryIndicatorScrollStyleSameAsUserScroll;
        indicatorLineView.verticalMargin = 1;
//        indicatorLineView.indicatorWidth = 40;
        indicatorLineView.indicatorWidth = 24;

        
        pagerCategoryView.indicators = @[indicatorLineView];
        
        _categoryView = pagerCategoryView;
    }
    return _categoryView;
}


#pragma mark - JXCategoryViewDelegate -

// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    
}

// 点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    
}

// 滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{
    
}

// 正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

#pragma mark - JXCategoryListContainerViewDelegate -
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateTitles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    ZXOrderListViewController *couponVC = [[ZXOrderListViewController alloc] init];
    couponVC.pageType = (int)index;
    return couponVC;
}

@end
