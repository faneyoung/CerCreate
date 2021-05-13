//
//  ZXMemberFeeCouponCell.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMemberFeeCouponCell.h"

#import "CJLabel.h"
#import <YYLabel.h>


@interface ZXMemberFeeCouponCell ()
@property (nonatomic, strong) YYLabel *desLab;

@end

@implementation ZXMemberFeeCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _desLab = [[YYLabel alloc] init];
    _desLab.font = FONT_PINGFANG_X(14);
    _desLab.textColor = kThemeColorMain;
    [self.contentView addSubview:self.desLab];
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(32);
        make.height.mas_equalTo(28);
        make.centerY.offset(0);
    }];

    ViewBorderRadius(self.desLab, 14.0, 1,kThemeColorMain);
    self.desLab.textContainerInset = UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXCouponListModel*)selectCoupon cal:(ZXCouponCalculationModel*)calModel{
    self.desLab.layer.borderColor = kThemeColorMain.CGColor;
    
    self.desLab.text = [NSString stringWithFormat:@"￥%@ 会员费抵扣券/-￥%@",selectCoupon.faceValue,calModel.deductionAmount];

}

- (void)updateWithData:(id)model{
    
   if([model isKindOfClass:NSArray.class]){
        self.desLab.layer.borderColor = UIColor.whiteColor.CGColor;
       
        self.desLab.text = [NSString stringWithFormat:@"%d张优惠券",(int)((NSArray*)model).count];
    }
    
}

@end
