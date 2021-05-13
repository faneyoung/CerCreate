//
//  ZXNormalBankCardCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/20.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXNormalBankCardCell.h"
#import "ZXSDBankCardModel.h"

@interface ZXNormalBankCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *cardLab;

@property (nonatomic, strong) ZXSDBankCardItem *card;

@end

@implementation ZXNormalBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXSDBankCardItem*)model{
    self.card = model;
    
    [self.imgView sd_setImageWithURL:GetString(model.bankIcon).URLByCheckCharacter placeholderImage:UIImageNamed(@"mine_banckcard")];
    
}

- (void)setIsMainCard:(BOOL)isMainCard{
    _isMainCard = isMainCard;
    
    NSString *type = isMainCard ? @"工资卡" : @"其他银行卡";
    
    NSString *cardNum  = [self.card.number substringWithnumber:4 reverse:YES];
    
    NSString *cardInfoStr = [NSString stringWithFormat:@"%@ %@ %@",GetStrDefault(self.card.bankName, @""),type,cardNum];
    self.cardLab.text = cardInfoStr;

}

@end
