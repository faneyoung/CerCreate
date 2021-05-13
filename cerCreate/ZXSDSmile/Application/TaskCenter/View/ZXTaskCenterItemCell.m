//
//  ZXTaskCenterItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/18.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskCenterItemCell.h"
#import "UIButton+Align.h"

#import "ZXTaskCenterModel.h"

@interface ZXTaskCenterItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *topShodow;
@property (weak, nonatomic) IBOutlet UILabel *bottomShodow;
@property (weak, nonatomic) IBOutlet UILabel *bottomSepLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;

@end

@implementation ZXTaskCenterItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 4, 0.01, UIColor.whiteColor);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXTaskCenterItem*)model{
    
    self.topShodow.hidden = self.bottomShodow.hidden = NO;
    
    self.titleLab.text = GetString(model.certTitle);
    
    [self.imgView sd_setImageWithURL:GetString(model.icon).URLByCheckCharacter placeholderImage:UIImageNamed(model.placeholdImg)];
    
    UIColor *staColor = TextColorSubTitle;
    UIImage *statArrImg = UIImageNamed(@"icon_task_arrow_gray");

    if ([model.certStatus isEqualToString:@"NotDone"] ||
        [model.certStatus isEqualToString:@"Submit"] ||
        [model.certStatus isEqualToString:@"ToComputeQuota"]) {
        staColor = kThemeColorMain;
        statArrImg = UIImageNamed(@"icon_task_arrow_green");
    }
    else if ([model.certStatus isEqualToString:@"Expired"] ||
             [model.certStatus isEqualToString:@"Fail"]){
        staColor = kThemeColorOrange;
        statArrImg = UIImageNamed(@"icon_task_arrow_orange");
    }
    
//    if ([model.certTitle isEqualToString:@"微信公众号"]) {
//        model.certStatusDesc = @"加关注";
//        staColor = kThemeColorMain;
//        statArrImg = UIImageNamed(@"icon_arrow_green");
//
//    }
//    else if ([model.certTitle isEqualToString:@"企业微信号"]) {
//        model.certStatusDesc = @"加好友";
//        staColor = kThemeColorMain;
//        statArrImg = UIImageNamed(@"icon_arrow_green");
//
//    }

    [self.statusBtn setTitle:GetStrDefault(model.certStatusDesc,@"") forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:staColor forState:UIControlStateNormal];
    self.statusImgView.image = statArrImg;

}

- (void)setIsBottom:(BOOL)isBottom{
    _isBottom = isBottom;
    self.bottomShodow.hidden = isBottom;
    
    if (isBottom) {
        self.topShodow.hidden = NO;
    }
    
    self.bottomSepLine.hidden = isBottom;
}


@end
