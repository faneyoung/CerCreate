//
//  ZXCompanySearchModel.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/13.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCompanySearchModel.h"

@implementation ZXCompanySearchModel

- (NSAttributedString *)name{
    if (!_name) {
        if (IsValidString(self.keyWord)) {
            
            if (IsValidString(self.companyName)) {
                
               NSRange range = [self.companyName rangeOfString:self.keyWord];
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:GetString(self.companyName)];

                [attributedString addAttribute:NSFontAttributeName value:FONT_PINGFANG_X(14) range:range];
                [attributedString addAttribute:NSForegroundColorAttributeName value:kThemeColorRed range:range];
                
                _name = attributedString;
            }
            else{
                _name = nil;
            }
            
        }
        else{
            _name = [[NSMutableAttributedString alloc] initWithString:GetString(self.companyName) attributes:@{NSForegroundColorAttributeName : TextColorTitle,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0]}];
        }
        
    }
    
    return _name;
}

@end
