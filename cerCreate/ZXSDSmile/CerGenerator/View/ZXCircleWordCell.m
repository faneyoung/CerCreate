//
//  ZXCircleWordCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCircleWordCell.h"

@implementation ZXCircleWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.font = Font_Songti(50, ZXSDFontStyleBold);
}

@end
