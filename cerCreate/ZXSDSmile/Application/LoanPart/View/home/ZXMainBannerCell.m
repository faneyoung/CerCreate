//
//  ZXMainBannerCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/31.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMainBannerCell.h"
#import "ZXMainBannerView.h"
#import "ZXBannerModel.h"

@interface ZXMainBannerCell () <ZXMainBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSHeight;

@property (nonatomic, strong) ZXMainBannerView *bannerView;
@property (nonatomic, strong) NSArray *bannerModels;

@end

@implementation ZXMainBannerCell

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
    
    self.bannerView = [[ZXMainBannerView alloc] init];
    self.bannerView.pageIndicatorSpaing = 3;
    self.bannerView.delegate = self;
    self.bannerView.backgroundColor = UIColor.whiteColor;
    ViewBorderRadius(self.bannerView, 4, 0.01, UIColor.whiteColor);
    [self.containerView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];

}

- (void)updateWithData:(id)model{
    
    
    self.bannerModels = model;
    [self.bannerView updateViewWithModel:model];
    
    CGFloat height = (SCREEN_WIDTH()-2*16)*128/343;
    self.containerCSHeight.constant = height;
    [self.containerView layoutIfNeeded];
    [self.contentView layoutIfNeeded];
        
}

#pragma mark - bannerDelegate -

- (void)bannerView:(UIView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerClickedBlock) {
        self.bannerClickedBlock((int)index);
    }
    
}


@end
