//
//  ZXMemberOptionMoreLevelCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/25.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberOptionMoreLevelCell.h"


@interface ZXMemberOptionMoreLevelCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation ZXMemberOptionMoreLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsFirstRow:(BOOL)isFirstRow{
    _isFirstRow = isFirstRow;
    
    if (isFirstRow) {
        self.desLab.font = self.statusLab.font = FONT_PINGFANG_X(13);
        

    }
    else{
        self.desLab.font = self.statusLab.font = FONT_PINGFANG_X_Medium(13);
    }

}

- (void)updateViewsWithData:(NSDictionary*)data{
    self.titleLab.text = [data stringObjectForKey:@"title"];
    self.statusLab.text = [data stringObjectForKey:@"status"];
    self.desLab.text = [data stringObjectForKey:@"des"];

}






@end
