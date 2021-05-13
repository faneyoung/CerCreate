//
//  ZXSDHomeHeaderView.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/11/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeHeaderView.h"
#import "AppDelegate+setting.h"

@interface ZXSDHomeHeaderView ()

@property (nonatomic, strong) ZXSDHomeLoanInfo *loanInfo;
@property (nonatomic, strong) UIView *header; //contentview

@property (nonatomic, strong) UILabel *companyLab;
@property (nonatomic, strong) UIButton *companyBtn;
@property (nonatomic, strong) UIButton *msgBtn;


@end

@implementation ZXSDHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    [self addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(kNavigationBarNormalHeight);
    }];
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgBtn setImage:UIImageNamed(@"icon_home_msg") forState:UIControlStateNormal];
    [msgBtn setImage:UIImageNamed(@"icon_home_msg_red") forState:UIControlStateSelected];
    [msgBtn addTarget:self action:@selector(msgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:msgBtn];
    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.inset(0);
        make.width.mas_equalTo(52);
    }];
    self.msgBtn = msgBtn;


    UILabel *cLab = [UILabel labelWithText:@"" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(22)];
    cLab.userInteractionEnabled = YES;
    @weakify(self);
    [cLab bk_whenTouches:1 tapped:1 handler:^{
        @strongify(self);
        [self doEmployerAction];
    }];
    [self.header addSubview:cLab];
    [cLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(0);
        make.left.inset(16);
    }];
    self.companyLab = cLab;
    
    UIButton *employerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [employerBtn setImage:UIImageNamed(@"icon_home_dropdown") forState:UIControlStateNormal];
    [employerBtn addTarget:self action:@selector(doEmployerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:employerBtn];
    [employerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cLab);
        make.left.mas_equalTo(cLab.mas_right).inset(5);
        make.width.height.mas_equalTo(25);
    }];
    self.companyBtn = employerBtn;
    


}

- (void)configWithData:(ZXSDHomeLoanInfo *)info
{
    self.loanInfo = info;

    BOOL verifiedSmilePlus = [self.loanInfo.extraInfo.userRole isEqualToString:@"smile"] && [self.loanInfo.extraInfo.smileStatus isEqualToString:@"Accept"];
    
    NSString *companyName = @"欢迎来到薪朋友";
    if (verifiedSmilePlus) {
        companyName = GetString(self.loanInfo.extraInfo.companyName);
    }
    
    self.companyLab.text = companyName;
    
    BOOL showEntrace = self.loanInfo.extraInfo.canEditJobInfo;
    self.companyBtn.userInteractionEnabled = showEntrace;
    self.companyLab.userInteractionEnabled = showEntrace;
}

- (void)setHasNewMsg:(BOOL)hasNewMsg{
    _hasNewMsg = hasNewMsg;
    
    self.msgBtn.selected = hasNewMsg;
}

#pragma mark - action methods -

- (void)doEmployerAction
{
    if (self.employerAction) {
        self.employerAction();
    }
}

- (void)msgBtnClick{

    [AppDelegate clearBadge];
    
    [URLRouter routerUrlWithPath:kURLRouter_messageMain extra:nil];
}


#pragma mark - Getter

- (UIView *)header
{
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 44)];
        _header.backgroundColor = UIColor.whiteColor;
    }
    return _header;
}

@end
