//
//  ZXBrandStoryItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBrandStoryItemCell.h"
#import "ZXBannerModel.h"

@interface ZXBrandStoryItemCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation ZXBrandStoryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.1, UIColor.clearColor);
    [self homeCardShadowSetting];

    
}

- (void)updateViewWithModel:(ZXBannerModel*)data{
    
    [self.imgView setImgWithUrl:data.cover];
    self.titleLab.text = GetString(data.name);
    
}


#pragma mark - help methods -
- (void)homeCardShadowSetting{
    CALayer *shadowLayer = self.layer;
    shadowLayer.cornerRadius = 8;
    shadowLayer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0,3);
    shadowLayer.shadowRadius = 6;
    shadowLayer.shadowOpacity = 0.6;
    shadowLayer.masksToBounds = NO;
}


@end
