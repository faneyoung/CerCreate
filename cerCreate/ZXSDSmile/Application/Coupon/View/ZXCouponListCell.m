//
//  ZXCouponListCell.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/11.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXCouponListCell.h"
#import "UIView+help.h"
#import "UIButton+Align.h"

#import "ZXDrawArcView.h"

#import "ZXCouponListModel.h"

@interface ZXCouponListCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *topInfoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@property (nonatomic, strong) ZXCouponListModel *couponModel;

@end

@implementation ZXCouponListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 8, 0.01, UIColor.clearColor);
    ViewBorderRadius(self.useBtn, 16, 1, kThemeColorMain);
//    self.noteLab.preferredMaxLayoutWidth = SCREEN_WIDTH() - 80;
    self.imgView.hidden = YES;
    
    [self.noteBtn alignWithType:ButtonAlignImgTypeRight margin:8];
    
    self.selectBtn.userInteractionEnabled = NO;
    [self.selectBtn setImage:UIImageNamed(@"smile_loan_agreement_unselected") forState:UIControlStateNormal];
    [self.selectBtn setImage:UIImageNamed(@"smile_loan_agreement_selected") forState:UIControlStateSelected];
    
    self.topInfoView.backgroundColor = UIColor.clearColor;
    
    ZXDrawArcView *drawView = [[ZXDrawArcView alloc] init];
    drawView.frame = CGRectMake(0, 0, SCREEN_WIDTH()-2*20, 77);
    drawView.backgroundColor = UIColorFromHex(0xF7F9FB);
    [self.topInfoView addSubview:drawView];
    [self.topInfoView sendSubviewToBack:drawView];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateWithData:(ZXCouponListModel*)model{
    self.couponModel = model;
    self.imgView.hidden = YES;
    if (model.status == 2) {
        self.imgView.hidden = NO;
        self.imgView.image = UIImageNamed(@"icon_coupon_used");
    }
    else if(model.status == 3){
        self.imgView.hidden = NO;
        self.imgView.image = UIImageNamed(@"icon_coupon_overdue");
    }
    
    self.useBtn.hidden = !self.imgView.hidden;
    
    if (self.cellType == CouponListCellTypeSelect) {
        self.useBtn.hidden = self.imgView.hidden = YES;
        self.selectBtn.hidden = NO;
    }
    else{
        self.selectBtn.hidden = YES;
    }
    self.selectBtn.selected = model.couponSelected;

    
    
    self.nameLab.text = GetString(model.name);
    self.timeLab.text = [NSString stringWithFormat:@"%@ - %@",GetString(model.created),GetString(model.expires)];
    self.priceLab.text = GetStrDefault(model.faceValue, @"0");
    
    
    if (model.selected) {
        self.noteLab.text = model.desc;
    }
    else{
        self.noteLab.text = @"";
    }
    
    self.noteBtn.selected = !self.selected;
    
    [self.noteLab layoutIfNeeded];
    [self.contentView layoutIfNeeded];


}


#pragma mark - action methods -

- (IBAction)noteBtnClicked:(UIButton*)sender {
    
    self.couponModel.selected = !self.couponModel.selected;
    
    if (self.couponListCellNoteBlock) {
        self.couponListCellNoteBlock(0);
    }
    
    [self rotationBtnImage:sender];
    
}

- (IBAction)useBtnClicked:(id)sender {
    if (self.couponListCellUseBlock) {
        self.couponListCellUseBlock(nil);
    }
}

//- (IBAction)selectBtnClicked:(UIButton*)sender {
//    self.couponModel.selected = !self.couponModel.selected;
//    sender.selected = !sender.selected;
//
//    if (self.couponListCellSelBlock) {
//        self.couponListCellSelBlock(self.couponModel);
//    }
//}

#pragma mark - help methods -
- (void)rotationBtnImage:(UIButton*)btn{
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:.25f];
    if(CGAffineTransformEqualToTransform(btn.imageView.transform,CGAffineTransformIdentity)){
        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        btn.imageView.transform =CGAffineTransformIdentity;
    }
    [UIView commitAnimations];

}

@end
