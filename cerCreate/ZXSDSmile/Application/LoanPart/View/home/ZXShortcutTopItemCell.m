//
//  ZXShortcutTopItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/1.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXShortcutTopItemCell.h"
#import "ZXBannerModel.h"

@interface ZXShortcutTopItemCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) ZXBannerModel *banner;



@end

@implementation ZXShortcutTopItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)updateViewWithModel:(ZXBannerModel*)data{
    self.banner = data;

    [self.imgView setImgWithUrl:data.cover];
    self.titleLab.text = GetString(data.name);
}

@end
