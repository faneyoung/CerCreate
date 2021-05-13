//
//  ZXMessageOptionCell.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMessageOptionCell.h"
#import "ZXMessageStatusModel.h"

@interface ZXMessageOptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *memberRedLab;
@property (weak, nonatomic) IBOutlet UILabel *activityRedLab;

@end

@implementation ZXMessageOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.memberRedLab.hidden = self.activityRedLab.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXMessageStatusModel*)model{
    self.memberRedLab.hidden = model.memberCount < 1;
    self.activityRedLab.hidden = model.activityCount < 1;
}

#pragma mark - action methods -


- (IBAction)memberBtnClick:(id)sender {
    if (self.optionBtnBlock) {
        self.optionBtnBlock(0);
    }
}

- (IBAction)promotionBtnClick:(id)sender {
    if (self.optionBtnBlock) {
        self.optionBtnBlock(1);
    }

}

@end
