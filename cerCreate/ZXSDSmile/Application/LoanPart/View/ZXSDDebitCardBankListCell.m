//
//  ZXSDDebitCardBankListCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDDebitCardBankListCell.h"

@interface ZXSDDebitCardBankListCell()

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;

@end

@implementation ZXSDDebitCardBankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)reloadSubviewsWithModel:(ZXSDDebitCardBankListModel *)model {
    if (model.bankPic.length > 0) {
        NSString *encodedString = GetString(model.bankPic);
        [self.bankLogoImageView sd_setImageWithURL:encodedString.URLByCheckCharacter placeholderImage:UIIMAGE_FROM_NAME(@"smile_bank_default")];
    } else {
        self.bankLogoImageView.image = UIIMAGE_FROM_NAME(@"smile_bank_default");
    }
    
    self.bankNameLabel.text = model.bankName;
    self.bankNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
    self.bankNameLabel.textColor = UICOLOR_FROM_HEX(0x333333);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
