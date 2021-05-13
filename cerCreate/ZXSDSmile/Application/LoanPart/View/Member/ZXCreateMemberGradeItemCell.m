//
//  ZXCreateMemberGradeItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCreateMemberGradeItemCell.h"
#import "ZXMemberGradeInfo.h"
#import <YYLabel.h>
#import "CJLabel.h"

@interface ZXCreateMemberGradeItemCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *gradeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceUnitLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLab;
@property (weak, nonatomic) IBOutlet CJLabel *activeLab;

@end

@implementation ZXCreateMemberGradeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 8, 2, UIColorFromHex(0xEAEFF2));
    
    self.activeLab.textInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    
}

- (void)updateViewWithModel:(ZXMemberGradeInfo*)data{
    self.gradeNameLab.text = data.describe;
    self.priceLab.text = GetString(data.amount);
    
    NSString *oriPriceStr = GetString(data.originalCost);
    if (IsValidString(oriPriceStr)) {
        oriPriceStr = [NSString stringWithFormat:@"原价 %@",oriPriceStr];
        
        NSMutableAttributedString * underAttr = [[NSMutableAttributedString alloc] initWithString:oriPriceStr attributes:@{
            NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle],
            NSForegroundColorAttributeName:UIColorFromHex(0xD8A655), NSFontAttributeName:FONT_PINGFANG_X(12)}];
        self.originPriceLab.attributedText = underAttr;

    }
    else{
        self.originPriceLab.text = @"";
    }
    
    UIColor *col = UIColorFromHex(0xEAEFF2);
    UIColor *titleColor = TextColorSubTitle;
    UIColor *originTitleColor = UIColorFromHex(0xA0AFC3);
    
    if (data.selected) {
        col = originTitleColor = UIColorFromHex(0xD8A655);
        titleColor = UIColorFromHex(0x976C38);
    }
    self.containerView.layer.borderColor = col.CGColor;
    self.originPriceLab.textColor = originTitleColor;
    
    self.priceLab.textColor = self.priceUnitLab.textColor = self.gradeNameLab.textColor = titleColor;
    
    if (data.hasActive) {
        self.activeLab.hidden = NO;

        self.activeLab.text = GetString(data.activeTitle);
    }
    else{
        self.activeLab.hidden = YES;
    }
    
}

@end
