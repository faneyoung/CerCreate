//
//  ZXPersonalItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXPersonalItemCell.h"
#import "ZXPersonalCenterModel.h"

@interface ZXPersonalItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;

@end

@implementation ZXPersonalItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descLab.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXPersonalCenterModel*)model{
    self.imgView.image = UIImageNamed(GetString(model.icon));
    self.titleLab.text = GetString(model.title);

    if (IsValidString(model.desc)) {
        self.descLab.hidden = NO;
        self.descLab.text = model.desc;
    }
    else{
        self.descLab.hidden = YES;
    }
}

@end
