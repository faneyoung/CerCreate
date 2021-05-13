//
//  ZXMainBannerItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/1.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMainBannerItemCell.h"

@interface ZXMainBannerItemCell ()
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZXMainBannerItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.layer.cornerRadius = 4;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    self.imgView = imgView;
}

#pragma mark - data -
- (void)updateContentViewWithData:(ZXBannerModel*)data{
    
    [self.imgView setImgWithUrl:data.cover];

}

@end
