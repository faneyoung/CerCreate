//
//  UILabel+align.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "UILabel+align.h"
#import<CoreText/CoreText.h>


@implementation UILabel (align)

- (void)textAlignmentLeftAndRight{

    if (!IsValidString(self.text)) {
        return;
    }
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size;
    CGFloat margin = (self.frame.size.width-textSize.width)/(self.text.length-1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributeString addAttribute:NSKernAttributeName value:number range:NSMakeRange(0, self.text.length-1)];
    self.attributedText = attributeString;
    
}

@end
