//
//  ZXMemberPayCardCell.m
//  ZXSDSmile
//
//  Created by Fane on 2020/11/30.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMemberPayCardCell.h"
#import "ZXSDBankCardModel.h"

@interface ZXMemberPayCardCell ()
@property (nonatomic, strong) ZXSDBankCardItem *model;

@end

@implementation ZXMemberPayCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusBtn.userInteractionEnabled = NO;
    
    [self.statusBtn setImage:UIImageNamed(@"smile_loan_agreement_unselected") forState:UIControlStateNormal];
    [self.statusBtn setImage:UIImageNamed(@"smile_loan_agreement_selected") forState:UIControlStateSelected];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXSDBankCardItem*)model{
    self.model = model;
    
    [self.imgView sd_setImageWithURL:[GetString(model.bankIcon) URLByCheckCharacter] placeholderImage:UIImageNamed(@"smile_bank_unionpay_gray")];
    
    NSString *cardNum = [model.number substringWithnumber:4 reverse:YES];
    self.nameLab.text = [NSString stringWithFormat:@"%@ 工资卡 %@",GetString(model.bankName),GetString(cardNum)];
    self.statusBtn.selected = model.selected;
    
}

#pragma mark - action methods -

- (IBAction)statusBtnClick:(UIButton*)sender {
//    sender.selected = !sender.selected;
//    self.model.selected = sender.selected;
//
//    if (self.cardSelectedBlock) {
//        self.cardSelectedBlock(self.model);
//    }
//
//
}

@end
