//
//  ZXAmoutEvaluateDesCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmoutEvaluateDesCell.h"

@interface ZXAmoutEvaluateDesCell ()
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation ZXAmoutEvaluateDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(id)model{
    self.desLab.text = model;
}

@end
