//
//  ZXAmountEvaluateRefItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/9.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmountEvaluateRefItemCell.h"
#import "ZXTaskCenterModel.h"
#import "UIButton+Align.h"


@interface ZXAmountEvaluateRefItemCell ()
@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (nonatomic, strong) ZXTaskCenterItem *taskItem;


@end

@implementation ZXAmountEvaluateRefItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.uploadBtn.userInteractionEnabled = NO;
    ViewBorderRadius(self.contentview, 4, 0.01, UIColor.whiteColor);
    
}

#pragma mark - data handle -

/** NotDone & Fail   ||   Submit & humanCheck*/
- (void)updateViewWithModel:(ZXTaskCenterItem*)item{
    
//#warning &&&& test -->>>>>
//    item.certStatus = @"NotDone";
//#warning <<<<<<-- test &&&&

    self.taskItem = item;

    UIImage *img = UIImageNamed(@"icon_amountAvaluate_ali");
    UIColor *aniColor = UIColorFromHex(0x3C74CE);
    UIColor *aniBgColor = UIColorFromHex(0xF3F8FF);
    
    if ([item.certKey isEqualToString:@"referScoreWechat"]) {
        aniColor = kThemeColorMain;
        aniBgColor = UIColorFromHex(0xF2FFF6);
        img = UIImageNamed(@"icon_amountAvaluate_wx");
        
        [self.uploadBtn setBackgroundImage:GradientImageHoriz(@[UIColorFromHex(0x00B050),UIColorFromHex(0x00C35A)]) forState:UIControlStateNormal];
    }
    else{
        [self.uploadBtn setBackgroundImage:GradientImageHoriz(@[UIColorFromHex(0x3C74CE),UIColorFromHex(0x5886E2)]) forState:UIControlStateNormal];
    }
    
    
    self.titleLab.text = GetStrDefault(item.certTitle, @"");
    self.imgView.image = img;
    self.contentview.backgroundColor = aniBgColor;
    [self.uploadBtn setTitle:item.certStatusDesc forState:UIControlStateNormal];
    
    if([item.certStatus isEqualToString:@"Submit"] ||
       [item.certStatus isEqualToString:@"humanCheck"]){
        
        [self.uploadBtn setImage:UIImageNamed(@"icon_circle_loading") forState:UIControlStateNormal];
        [self.uploadBtn alignWithType:ButtonAlignImgTypeLeft margin:7];
        
        [self rotateViewAnimationWithView:self.uploadBtn.imageView];
    }
    else{ //NotDone & Fail
        [self.uploadBtn setImage:nil forState:UIControlStateNormal];
    }
}

- (void)rotateViewAnimationWithView:(UIView *)view {

    [view.layer removeAnimationForKey:@"kRotateViewAnimation"];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue         = @(0);
    rotationAnimation.toValue           = @((M_PI * 100000 *1.5));
    rotationAnimation.duration          = 100000;
    rotationAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [view.layer addAnimation:rotationAnimation forKey:@"kRotateViewAnimation"];
}


@end
