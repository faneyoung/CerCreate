//
//  ZXHomeBannerCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeBannerCell.h"
#import "ZXBannerView.h"

@interface ZXHomeBannerCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) ZXBannerView *bannerView;


@end

@implementation ZXHomeBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - views -
- (void)initView{
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = UIImageNamed(@"smile_home_joinedbg");
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(20);
        make.bottom.inset(30);
        make.height.mas_equalTo(80);
    }];
    self.imgView = imgView;
    
    self.bannerView = [[ZXBannerView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.bannerType = WLBannerViewTypeMine;
    self.bannerView.backgroundColor = UIColor.whiteColor;
    ViewBorderRadius(self.bannerView, 4, 0.01, UIColor.whiteColor);
    [self.contentView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(20);
        make.bottom.inset(20);
        make.height.mas_equalTo(90);
    }];
    self.bannerView.hidden = YES;

}

- (void)updateViewsWithData:(id)data{
    if ([data isKindOfClass:UIImage.class]) {
        self.bannerView.hidden = YES;
        self.imgView.image = data;

    }
    else{
        self.bannerView.hidden = NO;
        [self.bannerView updateViewWithModel:data];
    }
}

#pragma mark - bannerDelegate -

- (void)bannerView:(UIView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerClickedBlock) {
        self.bannerClickedBlock(index);
    }
}

@end
