//
//  ZXMineMemberCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMineMemberCell.h"

@interface ZXMineMemberCell ()
@property (weak, nonatomic) IBOutlet UIView *memberContainerView;
@property (weak, nonatomic) IBOutlet UIView *memberTimeView;

@property (weak, nonatomic) IBOutlet UIImageView *shadowView;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;
@end

@implementation ZXMineMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeBtn.userInteractionEnabled = self.fetchBtn.userInteractionEnabled = NO;
    ViewBorderRadius(self.memberTimeView, 8, 0.01, UIColor.clearColor);
        
    self.shadowView.image = [UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0xFFDDA8),UICOLOR_FROM_HEX(0xFED083)] direction:UIImageGradientDirectionVertical];
    self.timeLab.font = FONT_Akrobat_Semibold(13);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data -
- (void)updateWithData:(id)model{
    
    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
    
    self.timeLab.hidden = self.timeBtn.hidden = !userModel.isCustomer;
    self.fetchBtn.hidden = userModel.isCustomer;
    
    if (userModel.isCustomer) {
        self.timeLab.text = [NSString stringWithFormat:@"%@ - %@",GetString(userModel.validDateTime),GetString(userModel.invalidDateTime)];
    }
    
}

#pragma mark - action methods -

- (IBAction)memberCreateBtnClicked:(id)sender {

//    if (self.memberStatusBlock) {
//        self.memberStatusBlock(0);
//    }
}

- (IBAction)memberRenewClicked:(id)sender {
//    if (self.memberStatusBlock) {
//        self.memberStatusBlock(1);
//    }
}

@end
