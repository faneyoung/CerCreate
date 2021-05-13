//
//  ZXMemberPayInfoCell.m
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMemberPayInfoCell.h"
#import "ZXMemberGradeInfo.h"

extern NSInteger ZXSD_MEMBER_FEE;
extern NSInteger ZXSD_MEMBER_FEE_Due;

@interface ZXMemberPayInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *sepLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconCSWidth;

@end

@implementation ZXMemberPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXMemberGradeInfo*)model{
    self.sepLab.hidden = YES;
    self.iconCSWidth.constant = 0;

    if (self.type == 1) {
        self.sepLab.hidden = NO;
//        self.iconCSWidth.constant = 16;
        
        self.titleLab.text = @"支付金额";
        
        NSString *title = [NSString stringWithFormat:@"￥%@",GetStrDefault(model.amount, @"-")];
        NSAttributedString *attr = [title attributeStrWithKeyword:GetStrDefault(model.amount, @"-") textColor:TextColorTitle font:FONT_SFUI_X_Medium(32) defaultColor:TextColorTitle alignment:NSTextAlignmentRight];
        self.contentLab.attributedText = attr;
    }
    else{

        self.titleLab.text = @"有效期";
        
        NSString *desc = @"";
        if (IsValidString(model.customerInvalidDate) && IsValidString(model.describe)) {
            desc = [NSString stringWithFormat:@"%@个月（%@）",model.cycle,model.customerInvalidDate];
        }
        self.contentLab.text = desc;
    }
    
    [self.contentView layoutIfNeeded];

}

@end
