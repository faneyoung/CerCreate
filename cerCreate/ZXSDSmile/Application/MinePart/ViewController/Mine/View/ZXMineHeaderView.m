//
//  ZXMineHeaderView.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMineHeaderView.h"
#import "UIView+help.h"
#import "UIView+help.h"

@interface ZXMineHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIImageView *topRightImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftImgView;


@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UILabel *couponNumLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLab;

@property (weak, nonatomic) IBOutlet UIView *memberContainerView;
@property (weak, nonatomic) IBOutlet UIView *memberTimeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberCSHeight;

@property (weak, nonatomic) IBOutlet UIImageView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *fetchBtn;


@end

@implementation ZXMineHeaderView

- (void)layoutSubviews{
    [super layoutSubviews];
    ViewBorderRadius(self.avatarImgView, 28, 0.01, UIColor.whiteColor);
    ViewBorderRadius(self.memberTimeView, 8, 0.01, UIColor.clearColor);
    
    [self bringSubviewToFront:self.topView];
    [self bringSubviewToFront:self.midView];
    [self bringSubviewToFront:self.memberTimeView];
    
    self.shadowView.image = [UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0xFFDDA8),UICOLOR_FROM_HEX(0xFED083)] direction:UIImageGradientDirectionVertical];
    
}

+ (instancetype)instanceMineHeaderView{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
    ZXMineHeaderView *headerView = [[nib instantiateWithOwner:nil options:nil] firstObject];
    headerView.fetchBtn.hidden = YES;
    [headerView bringSubviewToFront:headerView.nameLab];

    ViewBorderRadius(headerView.profileBtn, 11, 1, UIColorFromHex(0xCCD6DD));
    
//    [headerView.memberTimeView addRoundedCornerWithRadius:8 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
//    [headerView.shadowImgView makeInsetShadowWithRadius:50 Color:UIColorHexAlpha(0xFFDDA8, 1) Directions:@[@"bottom"]];

    return headerView;
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLab.text = GetStrDefault(name, @"");
}
-(void)setCouponNum:(NSString *)couponNum{
    _couponNum = couponNum;
    self.couponNumLab.text = GetStrDefault(couponNum, @"0");
}

- (void)setCardNum:(NSString *)cardNum{
    _cardNum = cardNum;
    self.cardNumLab.text = GetStrDefault(cardNum, @"0");
}

-(void)setMemberTime:(NSString *)memberTime{
    _memberTime = memberTime;
    
//    NSString *timeStr = memberTime;
//    if (IsValidString(memberTime)) {
//        timeStr = [NSString stringWithFormat:@"有效期 %@",memberTime];
//    }
//    else{
//        timeStr = @"";
//    }
    self.timeLab.text = memberTime;
    
}

- (void)setIsMember:(BOOL)isMember{
    _isMember = isMember;
    
    self.timeLab.hidden = self.timeBtn.hidden = !isMember;
    self.fetchBtn.hidden = isMember;
    
    CGFloat height = 56;
    if ([self isSmilePlusUser] && !isMember) {
        height = 0;
    }
    
    self.memberCSHeight.constant = height;
    [self layoutIfNeeded];
    
}

- (void)setAvatar:(NSString *)avatar{
    _avatar = avatar;
    
    if (IsValidString(avatar)) {
        [self.avatarImgView sd_setImageWithURL:GetString(avatar).URLByCheckCharacter placeholderImage:UIImageNamed(@"icon_avatar_default")];
    }
    else{
        self.avatarImgView.image = UIImageNamed(@"icon_avatar_default");
    }
}

- (BOOL)isSmilePlusUser{
    BOOL res = [[ZXSDCurrentUser currentUser].userRole isEqualToString:@"smile"];

    return res;
}

#pragma mark - action -


- (IBAction)couponBtnClicked:(id)sender{
    [URLRouter routerUrlWithPath:kRouter_couponList extra:nil];
}

- (IBAction)cardBtnClicked:(id)sender{
    if (self.cardManageBtnBlock) {
        self.cardManageBtnBlock();
    }
}

- (IBAction)profileBtnClicked:(id)sender {
    if (self.profileBtnBlock) {
        self.profileBtnBlock();
    }
}


- (IBAction)memberCreateBtnClicked:(id)sender {

    if (self.memberStatusBlock) {
        self.memberStatusBlock(0);
    }
}

- (IBAction)memberRenewClicked:(id)sender {
    if (self.memberStatusBlock) {
        self.memberStatusBlock(1);
    }
}


#pragma mark - help methods -

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
//    theView.layer.shadowColor = theColor.CGColor;
//    theView.layer.shadowOffset = CGSizeMake(0,0);
//    theView.layer.shadowOpacity = 0.5;
//    theView.layer.shadowRadius = 5;
//    // 单边阴影 顶边
//    float shadowPathWidth = theView.layer.shadowRadius;
//    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
//    theView.layer.shadowPath = path.CGPath;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:theView.bounds];
    theView.layer.masksToBounds = NO;
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
    theView.layer.shadowOpacity = 0.2f;
    theView.layer.shadowPath = shadowPath.CGPath;
}



@end
