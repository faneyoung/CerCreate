//
//  ZXCerLongTextCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCerLongTextCell.h"

@implementation ZXCerLongTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.textField, 8, 1, kThemeColorLine);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
