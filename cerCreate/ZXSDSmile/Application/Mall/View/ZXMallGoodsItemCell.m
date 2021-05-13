//
//  ZXMallGoodsItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMallGoodsItemCell.h"
#import "ZXGoodsModel.h"

@interface ZXMallGoodsItemCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSRight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation ZXMallGoodsItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceLab.font = FONT_Akrobat_ExtraBold(19);
}

- (void)setIsLeftItem:(BOOL)isLeftItem{
    _isLeftItem = isLeftItem;
    
    CGFloat left = 8;
    CGFloat right = 8;
    if (isLeftItem) {
        left = 16;
    }
    else{
        right = 16;
    }
    
    self.containerCSLeft.constant = left;
    self.containerCSRight.constant = right;
    
    [self.contentView layoutIfNeeded];
}

//- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes
//{
//    [self setNeedsLayout];
//    
//    [self layoutIfNeeded];
//    
//    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
//    
//    CGRect cellFrame = layoutAttributes.frame;
//    
//    cellFrame.size.height= size.height;
//    
//    layoutAttributes.frame= cellFrame;
//    
//    return layoutAttributes;
//    
//}

#pragma mark - data -
- (void)updateWithData:(ZXGoodsModel*)data{
    if (data.showBlankView) {
        self.imgView.image = nil;
        self.titleLab.text = nil;
        self.priceLab.text = nil;
        self.imgView.backgroundColor = UIColor.whiteColor;
        return;
    }
    
    self.imgView.backgroundColor = kThemeColorBg;

    if (!IsValidString(data.showMages)) {
        self.imgView.image = UIImageNamed(@"icon_placeholer");
        self.imgView.contentMode = UIViewContentModeCenter;
    }
    else{
        [self.imgView setImgWithUrl:data.showMages completed:^(UIImage * _Nonnull image) {
            if (image) {
                self.imgView.backgroundColor = UIColor.whiteColor;
            }
        }];
    }

    
    
    self.titleLab.text = GetString(data.commodityName);
    
    
    self.priceLab.text = GetString(data.showAmount);
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
    
    
}

@end
