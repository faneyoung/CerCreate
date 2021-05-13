//
//  ZXBuyCouponInfoCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBuyCouponInfoCell.h"
#import "ZXCouponRuleModel.h"

@interface ZXBuyCouponInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *payLab;

@end

@implementation ZXBuyCouponInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    self.containerView.layer.shadowOpacity = 1;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 8;
    self.containerView.layer.cornerRadius = 8;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXCouponRuleModel*)model{
    self.nameLab.text = GetStrDefault(model.name, @"预支神券");
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",GetStrDefault(model.created, @"-"),GetStrDefault(model.expires, @"-")];
    self.desLab.text = GetString(model.desc);
    
    self.priceLab.text = GetStrDefault(model.faceValue, @"5");
    self.payLab.text = GetStrDefault(model.faceValue, @"5");

    
}

/**
 *  周边加阴影，并且同时圆角
 */
- (UIView *)addShadowToView:(UIView *)view withOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius andCornerRadius:(CGFloat)cornerRadius {
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    
    UIView *shadowView = [[UIView alloc] init];
    shadowView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    shadowView.layer.shadowOpacity = shadowOpacity;
    shadowView.layer.shadowRadius = shadowRadius;
    shadowView.layer.cornerRadius = cornerRadius;
    shadowView.clipsToBounds = NO;
    [shadowView addSubview:view];
    return shadowView;
}


@end
