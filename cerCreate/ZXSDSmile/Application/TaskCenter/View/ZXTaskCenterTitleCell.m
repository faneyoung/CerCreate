//
//  ZXTaskCenterTitleCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/14.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskCenterTitleCell.h"

@interface ZXTaskCenterTitleCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSTop;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewCSHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ZXTaskCenterTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.01, UIColor.whiteColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewsWithData:(id)data{
    self.titleLab.text = GetString(data);
}

- (void)setIsFirstRow:(BOOL)isFirstRow{
    _isFirstRow = isFirstRow;
    
    if (isFirstRow) {
        self.containerCSTop.constant = 16;
    }
    else{
        self.containerCSTop.constant = 8;
    }
    
    [self.contentView layoutIfNeeded];
    
}

- (void)setCustomTitleView:(BOOL)customTitleView{
    _customTitleView = customTitleView;
    if (customTitleView) {
        self.containerViewCSHeight.constant = 50;
    }
    else{
        self.containerViewCSHeight.constant = 40;
    }
    [self.contentView layoutIfNeeded];

}

@end
