//
//  ZXHomeCollegeCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeCollegeCell.h"
#import "ZXMainBannerView.h"
#import <TYPageControl.h>

@interface ZXHomeCollegeCell () <ZXMainBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSHeight;

@property (nonatomic, strong) ZXMainBannerView *bannerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@property (nonatomic, strong) NSArray *bannerModels;

@end

@implementation ZXHomeCollegeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - views -
- (void)setupSubviews{
    
    ViewBorderRadius(self.containerView, 4, .1, kThemeColorLine);
    [self.shadowView homeCardShadowSetting];

    
    self.bannerView = [[ZXMainBannerView alloc] init];
    self.bannerView.autoScroll = NO;
    self.bannerView.delegate = self;
    self.bannerView.backgroundColor = UIColor.whiteColor;
    ViewBorderRadius(self.bannerView, 4, 0.01, UIColor.whiteColor);
    [self.containerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(16);
        make.top.inset(50);
        make.bottom.inset(38);
    }];
    self.bannerView.hidePageControl = YES;
    CGFloat width = SCREEN_WIDTH() - 4*16;
    CGFloat height = width*96/311.0;
    self.bannerView.contentSize = CGSizeMake(width, height);
    
    [self addPageControl];

}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.pageIndicatorSpaing = 3;
    pageControl.currentPageIndicatorSize = CGSizeMake(12, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.currentPageIndicatorTintColor = kThemeColorMain;
    pageControl.pageIndicatorTintColor = TextColorgray;
    [self.containerView addSubview:pageControl];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).inset(16);
        make.left.right.inset(0);
        make.height.mas_equalTo(6);
    }];
    
    _pageControl = pageControl;
}

#pragma mark - data -

- (void)updateWithData:(id)model{
    self.bannerModels = model;
    [self reloadPageData];
    
    CGFloat width = SCREEN_WIDTH() - 4*16;
    CGFloat height = width*96/311.0;
    
    self.containerCSHeight.constant = 184 + (height-96);
    [self.contentView layoutIfNeeded];
    
}

- (void)reloadPageData{
    _pageControl.numberOfPages = self.bannerModels.count;
    _pageControl.hidden = !IsValidArray(self.bannerModels);
    [self.bannerView updateViewWithModel:self.bannerModels];
}


#pragma mark - bannerDelegate -
- (void)pagerView:(UIView *)bannerView didScrollAIndex:(NSInteger)toIndex{
    self.pageControl.currentPage = toIndex;
}

- (void)bannerView:(UIView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerClickedBlock) {
        self.bannerClickedBlock((int)index);
    }
    
}

@end
