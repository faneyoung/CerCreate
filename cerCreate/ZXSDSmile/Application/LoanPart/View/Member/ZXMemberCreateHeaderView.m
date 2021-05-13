//
//  ZXMemberCreateHeaderView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberCreateHeaderView.h"
#import "ZXMemberInfoModel.h"

@interface ZXMemberCreateHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBgImgView;
@property (weak, nonatomic) IBOutlet UIView *timeContainerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation ZXMemberCreateHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    ViewBorderRadius(self.infoView, 8, 0.01, UIColor.clearColor);
    self.infoBgImgView.image = [UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0xFFDDA8),UICOLOR_FROM_HEX(0xFED083)] direction:UIImageGradientDirectionVertical];
    self.timeContainerView.hidden = YES;
}

+ (instancetype)instanceMemberHeadView{
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ZXMemberCreateHeaderView" owner:nil options:nil];
    ZXMemberCreateHeaderView *view = views.firstObject;
    
    return view;
}

- (void)updateViewWithModel:(ZXMemberInfoModel*)model{
    
    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
    
    self.timeContainerView.hidden = !userModel.isCustomer;
    
    if (IsValidString(userModel.invalidDateTime)) {
        self.timeLab.text = [NSString stringWithFormat:@"%@ 到期",GetString(userModel.invalidDateTime)];
    }
    
}




@end
