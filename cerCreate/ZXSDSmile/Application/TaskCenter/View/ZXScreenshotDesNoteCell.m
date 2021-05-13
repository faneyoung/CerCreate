//
//  ZXScreenshotDesNoteCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/4.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScreenshotDesNoteCell.h"

@interface ZXScreenshotDesNoteCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ZXScreenshotDesNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(NSString*)model{
    self.titleLab.text = model;
    
}

@end
