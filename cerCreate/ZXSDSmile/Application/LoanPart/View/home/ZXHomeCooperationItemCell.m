//
//  ZXHomeCooperationItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeCooperationItemCell.h"
#import "ZXBannerModel.h"

@interface ZXHomeCooperationItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ZXHomeCooperationItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - data -

- (void)updateViewWithModel:(ZXBannerModel*)data{

    [self.imgView setImgWithUrl:data.cover];
    
    self.titleLab.text = GetString(data.name);
    
}

@end
