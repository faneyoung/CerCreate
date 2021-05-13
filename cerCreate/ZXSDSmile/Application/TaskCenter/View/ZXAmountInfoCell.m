//
//  ZXAmountInfoCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmountInfoCell.h"
#import "ZXAmountEvaluateListModel.h"

@interface ZXAmountInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomShadowLab;

@end

@implementation ZXAmountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.statusBtn.userInteractionEnabled = NO;
    
    ViewBorderRadius(self.containerView, 8, 0.01, UIColor.whiteColor);
    
    [self.statusBtn setImage:UIImageNamed(@"icon_amountEvaluate_fold") forState:UIControlStateNormal];
    [self.statusBtn setImage:UIImageNamed(@"icon_amountEvaluate_expand") forState:UIControlStateSelected];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXAmountEvaluateListModel*)model{
    
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:GetString(model.title)];
    NSRange range = [model.title rangeOfString:@"￥"];
    [attr addAttribute:NSFontAttributeName value:FONT_PINGFANG_X(13) range:range];
    NSRange rangeUnit = [model.title rangeOfString:@"/额度资格"];
    [attr addAttribute:NSFontAttributeName value:FONT_PINGFANG_X(13) range:rangeUnit];
    [attr addAttribute:NSForegroundColorAttributeName value:TextColorTitle range:rangeUnit];
    self.titleLab.attributedText = attr;
    
    self.statusLab.text = model.status;
    
    self.statusBtn.selected = model.isUnfold;
    self.bottomShadowLab.hidden = !model.isUnfold;
    
    UIColor *staColor = TextColorSubTitle;
    if ([model.statusCode isEqualToString:@"NotDone"] ||
        [model.statusCode isEqualToString:@"Submit"] ||
        [model.statusCode isEqualToString:@"ToComputeQuota"]) {
        staColor = kThemeColorMain;
    }
    else if ([model.statusCode isEqualToString:@"Expired"] ||
             [model.statusCode isEqualToString:@"Fail"]){
        staColor = kThemeColorOrange;
    }
    self.statusLab.textColor = staColor;
    
    
}

@end
