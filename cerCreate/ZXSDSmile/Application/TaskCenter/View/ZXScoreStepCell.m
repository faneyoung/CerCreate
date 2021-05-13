//
//  ZXScoreStepCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScoreStepCell.h"
#import "ZXScoreUploadModel.h"

@interface ZXScoreStepCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation ZXScoreStepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXScoreStepItemModel*)model{
    self.imgView.image = model.img;
    self.titleLab.text = model.title;
    self.desLab.text = model.des;
    
}

@end
