//
//  ZXCardListCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCardListCell.h"
#import "ZXSDBankCardModel.h"

@interface ZXCardListCell ()
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end

@implementation ZXCardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.cardView, 8, 0.1, UIColor.whiteColor);
    self.cardNumLab.adjustsFontSizeToFitWidth = YES;
    
    self.selBtn.userInteractionEnabled = NO;
    [self.selBtn setImage:UIImageNamed(@"choose_bank_uncheck") forState:UIControlStateNormal];
    [self.selBtn setImage:UIImageNamed(@"choose_bank_checked") forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXSDBankCardItem*)model{
    
    NSDictionary *config = [model UIConfig];
    
    
    self.cardView.backgroundColor = UICOLOR_FROM_HEX([config[@"color"] integerValue]);
    self.shadowImgView.image = [UIImage imageNamed:config[@"icon"]];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.bankIcon]];
    self.bankNameLab.text = model.bankName;
    
    self.cardNumLab.text = [self formatBankCardNumber:model.number];
    
    self.phoneNumLab.text = GetStrDefault(model.reservePhone, @"--");
    
    self.selBtn.selected = model.selected;
    
}

- (NSString *)formatBankCardNumber:(NSString *)number
{
    NSMutableString *result = [NSMutableString stringWithString:@"****  ****  ****  "];
    NSString *last = [number substringWithRange:NSMakeRange(number.length - 4, 4)];
    [result appendString:last];
    
    return result;
}

@end
