//
//  ZXAccountSecurityItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/27.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAccountSecurityItemCell.h"
#import "ZXAccountSecurityModel.h"

@interface ZXAccountSecurityItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (nonatomic, strong) ZXAccountSecurityModel *accountModel;

@end

@implementation ZXAccountSecurityItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXAccountSecurityModel*)model{
    self.accountModel = model;
    
    self.imageView.image = model.img;
    self.titleLab.text = model.title;

    if (model.status) {
        [self.statusBtn setTitle:@"未绑定" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:kThemeColorMain forState:UIControlStateNormal];
    }
    else{
        [self.statusBtn setTitle:@"已绑定" forState:UIControlStateNormal];
        [self.statusBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    }
}


@end
