//
//  ZXMemberOptionExtensionCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/25.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberOptionExtensionCell.h"

@interface ZXMemberOptionExtensionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UILabel *statusTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusDesLab;

@property (weak, nonatomic) IBOutlet UILabel *sepLab;


@end

@implementation ZXMemberOptionExtensionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sepLab.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsLastRow:(BOOL)isLastRow{
    _isLastRow = isLastRow;
    
    self.sepLab.hidden = !isLastRow;
    
}

- (void)updateViewsWithData:(NSDictionary*)data{
    self.statusDesLab.textColor = UIColorFromHex(0x976C38);
    
    self.titleLab.text = self.statusTitleLab.text = [data stringObjectForKey:@"title"];
    
    self.desLab.text = [data stringObjectForKey:@"des"];
    self.statusDesLab.text = self.desLab.text;
    
    NSString *status = [data stringObjectForKey:@"status"];
    if (IsValidString(status)) {
        self.statusDesLab.text = status;
        self.statusDesLab.textColor = kThemeColorRed;
    }
}

@end
