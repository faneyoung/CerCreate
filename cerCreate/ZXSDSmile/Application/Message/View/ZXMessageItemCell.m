//
//  ZXMessageItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXMessageItemCell.h"
#import "ZXMessageList.h"
#import "NSDate+help.h"

@interface ZXMessageItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation ZXMessageItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXMessageItem*)model{
    self.titleLab.text = model.title;
    self.contentLab.text = model.body;
    self.statusLab.hidden = !model.isNew;
    
    if (!IsValidString(model.created)) {
        self.timeLab.text = @"";
    }
    else{

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.created.longLongValue/1000];
        
        self.timeLab.text = [date getDateDisplayString];
        
    }

}

@end
