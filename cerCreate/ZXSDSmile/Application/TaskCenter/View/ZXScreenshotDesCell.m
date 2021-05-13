//
//  ZXScreenshotDesCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/3.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScreenshotDesCell.h"
#import "ZXScoreUploadStepDes.h"

@interface ZXScreenshotDesCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ZXScreenshotDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data handle -
- (void)updateWithData:(ZXScoreUploadStepDes*)model{
    self.titleLab.attributedText = model.attrTitle;
    [self.containerView removeAllSubviews];
    
    if (model.step == 2) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = UIImageNamed(model.imgs);
        [self.containerView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(15);
            make.centerX.offset(0);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(360);
        }];
    }
    else if(model.step == 1){
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = UIImageNamed(model.imgs);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.containerView addSubview:imgView];
        
        CGFloat itemWidth = (SCREEN_WIDTH() - 2*20 - 15)/2;
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(15);
            make.centerX.offset(0);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(100);
        }];

    }
    else{
        
        UIImageView *imgViewleft = [[UIImageView alloc] init];
        imgViewleft.image = UIImageNamed(model.imgs.firstObject);
        [self.containerView addSubview:imgViewleft];
        [imgViewleft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(15);
            make.left.inset(20);
            make.bottom.inset(15);
            make.height.mas_equalTo(100);
        }];

        UIImageView *imgViewRight = [[UIImageView alloc] init];
        imgViewRight.image = UIImageNamed(model.imgs.lastObject);
        [self.containerView addSubview:imgViewRight];
        [imgViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(imgViewleft);
            make.left.mas_equalTo(imgViewleft.mas_right).inset(15);
            make.right.inset(20);
            make.width.height.mas_equalTo(imgViewleft);
        }];

        
    }
    
    
    
}

@end
