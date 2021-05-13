//
//  ZXSecondaryBannerCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXSecondaryBannerCell.h"
#import "ZXMainBannerView.h"

@interface ZXSecondaryBannerCell () <ZXMainBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) ZXMainBannerView *bannerView;

@property (nonatomic, strong) NSArray *bannerModels;

@end

@implementation ZXSecondaryBannerCell

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
    
//    ViewBorderRadius(self.containerView, 8, .1, kThemeColorLine);
//    [self.shadowView homeCardShadowSetting];

    
    self.bannerView = [[ZXMainBannerView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.backgroundColor = UIColor.whiteColor;
    ViewBorderRadius(self.bannerView, 4, 0.01, UIColor.whiteColor);
    [self.containerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);

    }];
}

#pragma mark - data -

- (void)updateWithData:(id)model{
    self.bannerModels = model;
    [self.bannerView updateViewWithModel:self.bannerModels];
}


#pragma mark - bannerDelegate -

- (void)bannerView:(UIView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerClickedBlock) {
        self.bannerClickedBlock((int)index);
    }
    
}

@end
