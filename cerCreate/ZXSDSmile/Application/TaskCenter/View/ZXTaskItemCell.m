//
//  ZXTaskItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/9.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskItemCell.h"
#import "ZXTaskCenterModel.h"

@interface ZXTaskItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *topShodow;
@property (weak, nonatomic) IBOutlet UILabel *bottomShodow;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *sepLine;

@end

@implementation ZXTaskItemCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self hideBottomLine];
    ViewBorderRadius(self.containerView, 4, 0.01, UIColor.whiteColor);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(ZXTaskCenterItem*)model{
    
    self.topShodow.hidden = self.bottomShodow.hidden = NO;
    
    self.titleLab.textColor = TextColorTitle;
    
    
    UIColor *staColor = TextColorSubTitle;
    UIImage *statArrImg = UIImageNamed(@"icon_task_arrow_gray");
    
    if ([model.certStatus isEqualToString:@"NotDone"] ||
        [model.certStatus isEqualToString:@"Submit"]) {
        staColor = kThemeColorMain;
        statArrImg = UIImageNamed(@"icon_task_arrow_green");
    }
    else if ([model.certStatus isEqualToString:@"Expired"] ||
             [model.certStatus isEqualToString:@"Fail"]){
        staColor = kThemeColorOrange;
        statArrImg = UIImageNamed(@"icon_task_arrow_orange");
    }
    
    if ([model isExpandItem]) {
        self.titleLab.textColor = TextColorSubTitle;
        if (model.expand) {
            statArrImg = UIImageNamed(@"icon_amountEvaluate_fold");
            model.certTitle = @"收起提额任务";
        }
        else{
            model.certTitle = @"查看提额任务";
            statArrImg = UIImageNamed(@"icon_amountEvaluate_expand");
        }
    }
    
    self.titleLab.text = GetString(model.certTitle);

    [self.statusBtn setTitle:GetStrDefault(model.certStatusDesc,@"") forState:UIControlStateNormal];
    [self.statusBtn setTitleColor:staColor forState:UIControlStateNormal];
    self.statusImgView.image = statArrImg;

}

- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    self.topShodow.hidden = isTop;
    if (isTop) {
        self.bottomShodow.hidden = NO;
    }
}

- (void)setIsBottom:(BOOL)isBottom{
    _isBottom = isBottom;
    self.bottomShodow.hidden = isBottom;
    self.sepLine.hidden = isBottom;

    if (isBottom) {
        self.topShodow.hidden = NO;
    }
    
}



@end
