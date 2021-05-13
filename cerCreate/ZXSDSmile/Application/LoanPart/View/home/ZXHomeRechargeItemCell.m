//
//  ZXHomeRechargeItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXHomeRechargeItemCell.h"
#import "CJLabel.h"

#import "ZXBannerModel.h"

@interface ZXHomeRechargeItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *discountBgImgView;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation ZXHomeRechargeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceLab.font = FONT_Akrobat_ExtraBold(19);
    self.discountLab.font = FONT_Akrobat_ExtraBold(11);
    
}

#pragma mark - data -

- (void)updateViewWithModel:(ZXBannerModel*)data{
    self.imgView.backgroundColor = kThemeColorBg;
    
    ViewBorderRadius(self.imgView, 24, 0.01, UIColor.whiteColor);
    [self.imgView setImgWithUrl:data.cover completed:^(UIImage * _Nonnull image) {
        if (image) {
            self.imgView.backgroundColor = UIColor.whiteColor;
            self.imgView.layer.cornerRadius = 0;
        }
    }];
    self.titleLab.text = GetString(data.name);
    
    self.priceLab.text = @"";
    if (IsValidString(data.showAmount)) {
        NSString *price = data.showAmount;

        NSRange range = [price rangeOfString:@"￥"];
        
        if (range.location == NSNotFound) {
            price = [NSString stringWithFormat:@"￥%@",price];
            range = [price rangeOfString:@"￥"];
        }
                
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:price];
        [attr addAttribute:NSFontAttributeName value:FONT_Akrobat_Semibold(11) range:NSMakeRange(range.location,1)];
        self.priceLab.attributedText = attr;

    }
    
    self.discountLab.hidden = self.discountBgImgView.hidden = !IsValidString(data.discount);
    self.discountLab.text = GetString(data.discount);
    
    self.timeLab.text = GetString(data.desc);

    
}

@end
