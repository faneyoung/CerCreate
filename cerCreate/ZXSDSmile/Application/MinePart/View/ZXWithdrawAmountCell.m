//
//  ZXWithdrawAmountCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXWithdrawAmountCell.h"
#import "ZXSDWithdrawInfoModel.h"

@interface ZXWithdrawAmountCell ()
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTextfield;

@end

@implementation ZXWithdrawAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.amountTextfield.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data handle -

- (void)updateWithData:(ZXSDWithdrawInfoModel*)model{
    
    self.feeLab.text = [NSString stringWithFormat:@"提现金额  (服务费 ¥%.2f /次)", model.fee];

    self.amountTextfield.text = [NSString stringWithFormat:@"%.2f",model.amount>0?model.amount:0];
    
}


@end
