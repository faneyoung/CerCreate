//
//  ZXHomeWorkCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeWorkCell.h"
#import "UIView+help.h"
#import "ZXGalleryView.h"
#import "iCarousel.h"


#import "ZXBannerModel.h"


@interface ZXHomeWorkCell ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *itemContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemContainerCSHeight;

@property (nonatomic, strong) ZXGalleryView *galleryView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation ZXHomeWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.1, kThemeColorLine);
    [self.shadowView homeCardShadowSetting];

    int itemCount = 2;
    CGFloat margin = 16.0;
    CGFloat space = 8.0;
    CGFloat halfItem = 15.0;
    CGFloat width = SCREEN_WIDTH()-2*margin;
    CGFloat itemWidth = (width - itemCount*halfItem - (itemCount+1)*space)/itemCount;
    CGFloat itemHeight = itemWidth*128/148.0;
    
    _galleryView = [[ZXGalleryView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight) itemSize:CGSizeMake(itemWidth, itemHeight) space:space];
    _galleryView.delegate = self;
    _galleryView.itemSize = CGSizeMake(itemWidth, itemHeight);
    _galleryView.placeholdImage = @"icon_placeholer";
    _galleryView.hideTimer = YES;
    [self.itemContainerView addSubview:_galleryView];
    [_galleryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
}

- (CGSize)workItemSize{
    int itemCount = 2;
    CGFloat margin = 16.0;
    CGFloat space = 8.0;
    CGFloat halfItem = 15.0;
    CGFloat width = SCREEN_WIDTH()-2*margin;
    CGFloat itemWidth = (width - itemCount*halfItem - (itemCount+1)*space)/itemCount;
    CGFloat itemHeight = itemWidth*128/148.0;
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int itemCount = 2;
    CGFloat margin = 16.0;
    CGFloat space = 8.0;
    CGFloat halfItem = 15.0;
    CGFloat width = SCREEN_WIDTH()-2*margin;
    CGFloat itemWidth = (width - itemCount*halfItem - (itemCount+1)*space)/itemCount;
    CGFloat itemHeight = itemWidth*128/148.0;

    self.itemContainerCSHeight.constant = itemHeight;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - GalleryViewDelegate -
-(void)gallaryView:(ZXGalleryView*)galleryView didSelectedRowAtIndex:(NSInteger)index{
    if (index <= self.items.count-1) {
        ZXBannerModel *banner = self.items[index];
        [URLRouter routerUrlWithBannerModel:banner extra:@{@"bannerAnaly":@(YES)}];
    }
}

#pragma mark - data -
- (void)updateWithData:(NSArray*)model{
    self.items = model;
    
    __block NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:model.count];
    [model enumerateObjectsUsingBlock:^(ZXBannerModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgs addObject:obj.cover];
    }];
    
    self.galleryView.imageArr = imgs.copy;
}

@end
