//
//  ZXRecommendWorkCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/2.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXRecommendWorkCell.h"
#import "ZXMessageList.h"

@interface ZXRecommendWorkCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *patternLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@end

@implementation ZXRecommendWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewBorderRadius(self.cityLab, 2, 0.01, UIColor.whiteColor);
    ViewBorderRadius(self.patternLab, 2, 0.01, UIColor.whiteColor);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXMessageItem*)model{

    self.nameLab.text = GetString(model.title);
    self.cityLab.text = [NSString stringWithFormat:@" %@ ",GetString(model.district)];
    self.patternLab.text = [NSString stringWithFormat:@" %@ ",GetString(model.pattern)];
    
    self.distanceLab.text = GetString(model.distance);
    
    self.priceLab.text = GetString(model.salary);

//    if(!IsValidString(model.salary)){
//        self.priceLab.text = @"";
//    }
//    else{
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.salary];
//
//        NSRange range = [model.salary rangeOfString:@"￥"];
//        if (range.location != NSNotFound) {
//            [attr addAttribute:NSFontAttributeName value:FONT_PINGFANG_X_Medium(11) range:NSMakeRange(0, range.location+1)];
//        }
//
//        NSRange rangeUnit = [model.salary rangeOfString:@"/"];
//        if (rangeUnit.location != NSNotFound) {
//            CGFloat len = model.salary.length-rangeUnit.location;
//            [attr addAttribute:NSFontAttributeName value:FONT_PINGFANG_X_Medium(11) range:NSMakeRange(rangeUnit.location,len)];
//        }
//
//        self.priceLab.attributedText = attr;
//
//    }
    


}

@end
