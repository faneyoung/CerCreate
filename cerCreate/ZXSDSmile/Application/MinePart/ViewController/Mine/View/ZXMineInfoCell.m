//
//  ZXMineInfoCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMineInfoCell.h"
#import "UIView+help.h"

@interface ZXMineInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *authImgView;
@property (weak, nonatomic) IBOutlet UIImageView *payImgView;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *awardLab;
@property (weak, nonatomic) IBOutlet UILabel *couponLab;
@property (weak, nonatomic) IBOutlet UILabel *cardLab;


@end

@implementation ZXMineInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewBorderRadius(self.containerView, 8, 0.01, UIColor.whiteColor);
    [self.shadowView homeCardShadowSetting];
    
    ViewBorderRadius(self.avatarView, 28, 0.1, UIColor.whiteColor);
    
    @weakify(self);
    [self.avatarView bk_whenTapped:^{
        @strongify(self);
        if (self.infoActionBlock) {
            self.infoActionBlock(0);
        }

    }];
    
    self.amountLab.font = FONT_Akrobat_bold(22);
    self.awardLab.font = FONT_Akrobat_bold(22);
    self.couponLab.font = FONT_Akrobat_bold(22);
    self.cardLab.font = FONT_Akrobat_bold(22);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data -
- (void)updateWithData:(id)model{
    ZXUserModel *userModel = [ZXSDCurrentUser currentUser].userModel;
    
//#warning &&&& test -->>>>>
//    userModel.nickname = @"隔壁老王";
////    userModel.isVerify = YES;
////    userModel.isCustomer = YES;
//    userModel.avatar = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimgo.yqdown.com%2Fimg2021%2F2%2F19%2F21%2F20210219769767455209.jpg&refer=http%3A%2F%2Fimgo.yqdown.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1620294968&t=c68ac8c1d9dfaa98810e22b4ba7a7624";
//#warning <<<<<<-- test &&&&

    
    NSString *name = @"请认证";
    if (IsValidString(userModel.nickname)) {
        name = [NSString stringWithFormat:@"Hi, %@",GetString(userModel.nickname)];
    }
    self.nameLab.text = name;
    
    NSString *authImgName = @"icon_mine_auth";
    if (userModel.isVerify) {
        authImgName = @"icon_mine_auth_H";
    }
    self.authImgView.image = UIImageNamed(authImgName);
    
    NSString *payImgName = @"icon_mine_pay";
    if (userModel.isCustomer) {
        payImgName = @"icon_mine_pay_H";
    }
    self.payImgView.image = UIImageNamed(payImgName);
    
    [self.avatarView sd_setImageWithURL:userModel.avatar.URLByCheckCharacter placeholderImage:UIImageNamed(@"icon_mine_default_gray")];
    
    self.amountLab.text = GetStrDefault(userModel.quota, @"0");
    self.awardLab.text = GetStrDefault(userModel.balance, @"0");
    self.couponLab.text = GetStrDefault(userModel.commonCouponCount, @"0");
    self.cardLab.text = GetStrDefault(userModel.bankCardCount, @"0");
    
}

- (NSMutableAttributedString*)string:(NSString*)str keyword:(NSString*)keyword{
    NSString *amount = [NSString stringWithFormat:@"%@%@",GetStrDefault(str, @"0"),keyword];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:amount];
    NSRange range = [amount rangeOfString:keyword];
    if (range.location != NSNotFound) {
        [attr addAttribute:NSFontAttributeName value:FONT_PINGFANG_X(11) range:NSMakeRange(range.location,1)];
    }
    
    return attr;
}

#pragma mark - action methods -
- (IBAction)itemBtnClicked:(UIButton*)sender{

    if (self.infoActionBlock) {
        self.infoActionBlock((int)sender.tag-10);
    }
    
}

@end
