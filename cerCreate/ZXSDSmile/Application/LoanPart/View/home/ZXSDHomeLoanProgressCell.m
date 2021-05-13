//
//  ZXSDHomeLoanProgressCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/12.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeLoanProgressCell.h"

@interface ZXSDHomeLoanProgressCell ()

@property (nonatomic, strong) UIView *currentScale;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UIButton *nextActionBtn;

@property (nonatomic, strong) UIView *tipsBgView;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) ZXSDHomeLoanInfo *loanInfo;
@property (nonatomic, assign) NSInteger currentDay;

@property (nonatomic, strong) NSMutableArray *creditViews;
@property (nonatomic, strong) ZXSDHomeCreditItem *selectedCredit;

@end

static NSInteger kScaleNumber = 34;
static NSInteger kScalesContainerHeight = 50;
static NSInteger kAmountButtonHeight = 96;

@implementation ZXSDHomeLoanProgressCell

- (void)initView
{
    self.creditViews = [NSMutableArray new];
    
    // 预支按钮
    [self.contentView addSubview:self.actionBtn];
    
    CGFloat btnWidth = SCREEN_WIDTH()*242/375;
    CGFloat btnHeight = 48;
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(124);
        make.left.inset((SCREEN_WIDTH()-btnWidth)/2);
        make.bottom.inset(17);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);

    }];
    ViewBorderRadius(self.actionBtn, 24.0, 0.01, UIColor.clearColor);
    
    UIButton *nextActionBtn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(17) title:@"查看高薪工作" textColor:UIColor.whiteColor];
    nextActionBtn.backgroundColor = TextColorDisable;
    nextActionBtn.clipsToBounds = YES;

    [nextActionBtn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
    [nextActionBtn addTarget:self action:@selector(nextActionClicked:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(nextActionBtn, 24, 0.01, UIColor.clearColor);
    [self.contentView addSubview:nextActionBtn];
    [nextActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(20);
        make.centerY.mas_equalTo(self.actionBtn);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
    }];
    nextActionBtn.hidden = YES;
    self.nextActionBtn = nextActionBtn;
    
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDHomeLoanInfo class]]) {
        return;
    }
    
    self.loanInfo = renderData;
    
//#warning &&&& test -->>>>>
//  ZXSDHomeLoanActionModel *actionModel =  [[ZXSDHomeLoanActionModel alloc] init];
//    actionModel.title = @"预支神券";
//    actionModel.enable = [@(YES) stringValue];
//    self.loanInfo.nextActionModel = actionModel;
//#warning <<<<<<-- test &&&&

    [self freshPages];
    
}

- (void)freshPages
{
    if (self.loanInfo.loanModel.dayInterval < 0) {
        self.loanInfo.loanModel.dayInterval = 0;
    }
    if (self.loanInfo.loanModel.dayInterval > kScaleNumber) {
        self.loanInfo.loanModel.dayInterval = kScaleNumber;
    }
    
    // force update container‘s frame
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // update amounts
    [self updateAmounts2];
        
    // 底部按钮
    BOOL enabled = self.loanInfo.actionModel.enable.boolValue;
    NSString *status = self.loanInfo.actionModel.action;
    
    
    UIImage *bgImage = [UIImage imageWithColor:UICOLOR_FROM_HEX(0xF7F9FB)];
    if (enabled) {
        bgImage = MAIN_BUTTON_BACKGROUND_IMAGE;
    }
    
    [_actionBtn setTitleColor:enabled ?UICOLOR_FROM_HEX(0xFFFFFF) : UICOLOR_FROM_HEX(0xCCD6DD) forState:(UIControlStateNormal)];
    
    if ([status isEqualToString:ZXSDHomeUserApplyStatus_EMPLOYER_REJECT]) {
        bgImage = [UIImage imageWithColor:UICOLOR_FROM_HEX(0xFFA02E)];
    }
    else if ([status isEqualToString:ZXSDHomeUserApplyStatus_NORMAL_REPAY]){
        bgImage = [UIImage resizableImageWithGradient:@[UIColorFromHex(0x6C9CFF),kThemeColorBlue] direction:UIImageGradientDirectionLeftSlanted];
    }
    else if ([status isEqualToString:ZXSDHomeUserApplyStatus_OVERDUE_REPAY]) {
        bgImage = [UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0x6B9CFF),UICOLOR_FROM_HEX(0x5886E2)] direction:UIImageGradientDirectionHorizontal];
    }
    
    
    [_actionBtn setBackgroundImage:bgImage forState:(UIControlStateNormal)];
    
    
    //_actionBtn.layer.shadowOpacity = enabled ? 1: 0;
    _actionBtn.layer.shadowOpacity = 0;
    _actionBtn.userInteractionEnabled = enabled;
    
    [_actionBtn setTitle:self.loanInfo.actionModel.title forState:(UIControlStateNormal)];
    
    [self.nextActionBtn setTitle:self.loanInfo.nextActionModel.title forState:UIControlStateNormal];
    self.nextActionBtn.userInteractionEnabled = self.loanInfo.nextActionModel.enable;

    if (!self.loanInfo.nextActionModel.enable) {
        
        [self.nextActionBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.nextActionBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
    }
    else{
        [self.nextActionBtn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
        [self.nextActionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    
    
    CGFloat btnWidth = SCREEN_WIDTH()*242/375;

    if (!self.loanInfo.nextActionModel) {
        self.nextActionBtn.hidden = YES;
        
        [self.actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth);
            make.left.mas_equalTo((SCREEN_WIDTH()-btnWidth)/2);
        }];
        
        [self.nextActionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        
    }
    else{//神券&推荐高薪工作
        self.nextActionBtn.hidden = NO;
        CGFloat margin = 20;
        CGFloat space = 20;
        btnWidth = (SCREEN_WIDTH()-2*margin-space)/2;
        
        [self.actionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin);
            make.width.mas_equalTo(btnWidth);
        }];
        
        [self.nextActionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth);
        }];
        
        
    }
    
    [self.contentView layoutIfNeeded];
    
//    [self actionBtnShadowSetting:_actionBtn show:self.actionBtn.userInteractionEnabled];
//    [self actionBtnShadowSetting:self.nextActionBtn show:self.nextActionBtn.userInteractionEnabled];

    
}

- (void)updateAmounts2
{
    NSArray<ZXSDHomeCreditItem*> *creditAmounts = self.loanInfo.loanModel.creditUnitList;
    if (IsValidArray(self.creditViews)) {
        [self.creditViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.creditViews removeAllObjects];
    
    // 金额模块
//    CGFloat itemW = 80 * (SCREEN_WIDTH()/375.0);
    CGFloat offsetX = 16;
//    CGFloat gap = (SCREEN_WIDTH() - itemW * creditAmounts.count - offsetX * 2)/(creditAmounts.count - 1);
    int maxCount = 4;
    CGFloat  gap = 8;
    CGFloat itemW = (SCREEN_WIDTH() - 2*offsetX - (maxCount-1)*gap)/maxCount;
    
    NSInteger autoSelectedIndex = -1;
    for (NSInteger k = 0; k < creditAmounts.count; k++) {
        ZXSDHomeCreditItem *model = creditAmounts[k];
        
        if (model.eable && autoSelectedIndex < 0) {
            autoSelectedIndex = k;
        }
        
        //NSString *value = @(model.unit).stringValue;
        //UIButton *item = [self levelButtonWithValue:value highlighted:NO index:k];
        ZXSDHomeLoanAmountView *item = [[ZXSDHomeLoanAmountView alloc] initWithCreditItem:model highlighted:NO index:k];

        [self.contentView addSubview:item];
        item.frame = CGRectMake(offsetX + (gap + itemW) * k , 12, itemW, kAmountButtonHeight);
        item.tag = 1000 + k;
        
        @weakify(self);
        [item setCreditItemChoosedAction:^{
            @strongify(self);
            [self freshAmountStatus:k];
        }];
        
        [self.creditViews addObject:item];
    }
    
    [self freshAmountStatus:autoSelectedIndex];
}



- (void)confirmAction
{
    // 已经选中了可用的预支额度
    if (self.selectedCredit) {
        if (self.loanConfirmAction) {
            self.loanConfirmAction(@(self.selectedCredit.unit).stringValue);
        }
    } else {
        if (self.loanConfirmAction) {
            self.loanConfirmAction(nil);
        }
    }
}

#pragma mark - action -
- (void)nextActionClicked:(UIButton*)btn{
    if (!self.loanInfo.nextActionModel ||
        !IsValidString(self.loanInfo.nextActionModel.action)) {
        return;
    }

    NSMutableDictionary *tmps = @{}.mutableCopy;
    if ([self.loanInfo.nextActionModel.action isEqualToString:kRouter_recommendWork]) {
        [tmps setSafeValue:@"1" forKey:@"businessType"];
    }
    [URLRouter routerUrlWithPath:self.loanInfo.nextActionModel.action extra:tmps.copy];
}

/*
- (void)tipBtnAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    ZXSDHomeCreditItem *model = self.loanInfo.loanModel.creditUnitList[tag - 1000];
    
    
    NSInteger days = model.days;
    // 当前按钮的金额距离可用剩余天数
    if (days == 0) {
        
        if (model.eable && self.loanAdvanceSalaryAction) {
            self.loanAdvanceSalaryAction(@(model.unit).stringValue);
        }
        return;
    }
    
    // 提示
    [self showTips:sender days:days];
    
}*/

#pragma mark - Private

- (void)freshAmountStatus:(NSInteger)currentIndex
{
    for (ZXSDHomeLoanAmountView *item  in self.creditViews) {
        NSInteger index = item.tag - 1000;
        [item renderItemView:(index == currentIndex)];
        
        if (index == currentIndex) {
            self.selectedCredit = item.creditModel;
            
            [self homeCardShadowSettingWithView:item show:YES];
        }
        else{
            [self homeCardShadowSettingWithView:item show:NO];
        }
    }
}

- (void)homeCardShadowSettingWithView:(UIView*)view show:(BOOL)show{
    CALayer *shadowLayer = view.layer;
    shadowLayer.cornerRadius = 8;
    if (show) {
        view.layer.masksToBounds = NO;
        shadowLayer.shadowColor = kThemeColorMain.CGColor;
    }
    else{
        ViewBorderRadius(view, 8, 0.1, kThemeColorLine);
        shadowLayer.shadowColor = UIColor.whiteColor.CGColor;
    }
    shadowLayer.shadowOffset = CGSizeMake(0,4);
    shadowLayer.shadowRadius = 4;
    shadowLayer.shadowOpacity = 0.2;
    shadowLayer.masksToBounds = NO;
}

- (void)actionBtnShadowSetting:(UIView*)view show:(BOOL)show{
    CALayer *shadowLayer = view.layer;
    shadowLayer.cornerRadius = 24;
    
    shadowLayer.shadowOffset = CGSizeMake(0,4);
    shadowLayer.shadowRadius = 4;
    shadowLayer.shadowOpacity = 0.2;
    shadowLayer.masksToBounds = NO;

    if (show) {
        view.layer.masksToBounds = NO;
        shadowLayer.shadowColor = kThemeColorMain.CGColor;
    }
    else{
        ViewBorderRadius(view, 24, 0.1, kThemeColorLine);
        shadowLayer.shadowColor = UIColor.whiteColor.CGColor;
    }
}



#pragma mark - Getter

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_SFUI_X_Bold(12)];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}

- (UIButton *)actionBtn
{
    if (!_actionBtn) {
        _actionBtn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(17) title:@"立刻预支" textColor:UICOLOR_FROM_HEX(0xCCCCCC)];
        
        [_actionBtn setBackgroundImage:[UIImage imageWithColor:UICOLOR_FROM_HEX(0xF0F0F0)] forState:(UIControlStateNormal)];
            
        [_actionBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
        _actionBtn.layer.cornerRadius = 20;
        
        _actionBtn.layer.shadowColor = [kThemeColorMain colorWithAlphaComponent:0.4].CGColor;
        _actionBtn.layer.shadowOpacity = 0;
        _actionBtn.layer.shadowOffset = CGSizeMake(0, 4);
        _actionBtn.layer.shadowRadius = 4;
        _actionBtn.layer.masksToBounds = YES;
        
    }
    return _actionBtn;
}

@end

@interface ZXSDHomeLoanAmountView ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *amoutLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ZXSDHomeLoanAmountView

- (instancetype)initWithCreditItem:(ZXSDHomeCreditItem *)item highlighted:(BOOL)highlighted index:(NSInteger)index
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.creditModel = item;
        [self initView:highlighted index:index];
    }
    return self;
}

- (void)initView:(BOOL)highlighted index:(NSInteger)index
{    
    UIView *container = [UIView new];
    container.backgroundColor = UICOLOR_FROM_HEX(0xF7F9FB);
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.container = container;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosedItem:)];
    [container addGestureRecognizer:tap];
    
    UIColor *borderColor = highlighted?kThemeColorMain:UICOLOR_FROM_HEX(0xF7F9FB);
    container.layer.cornerRadius = 8;
    container.layer.borderWidth = 2;
    container.layer.borderColor = borderColor.CGColor;
    
    [container addSubview:self.amoutLabel];
    [self.amoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(22);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(26);
    }];
    
    [container addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amoutLabel.mas_bottom).offset(6);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    
    NSString *value = @(self.creditModel.unit).stringValue;
    self.amoutLabel.text = value;
    
    self.statusLabel.text = self.creditModel.title;
    
    UIColor *textColor = self.creditModel.eable ? UICOLOR_FROM_HEX(0x3C465A): UICOLOR_FROM_HEX(0xA0AFC3);
    if (highlighted) {
        textColor = kThemeColorMain;
    }
    
    self.amoutLabel.textColor = textColor;

}

- (void)renderItemView:(BOOL)highlighted
{
    if (!self.creditModel.eable) {
        return;
    }
    
    UIColor *borderColor = highlighted?kThemeColorMain:UICOLOR_FROM_HEX(0xF7F9FB);
    self.container.layer.borderColor = borderColor.CGColor;
    
    UIColor *textColor = self.creditModel.eable ? UICOLOR_FROM_HEX(0x3C465A): UICOLOR_FROM_HEX(0xA0AFC3);
    if (highlighted) {
        textColor = kThemeColorMain;
    }
    
    self.amoutLabel.textColor = textColor;
    
}

- (void)choosedItem:(id)sender
{
    // 不可用的金额,  不能点击
    if (!self.creditModel.eable) {
        return;
    }
        
    //[self renderItemView:YES];
    if (self.creditItemChoosedAction) {
        self.creditItemChoosedAction();
    }
}

- (UILabel *)amoutLabel
{
    if (!_amoutLabel) {
        UIFont *font = FONT_Akrobat_ExtraBold(28);
        _amoutLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:font];
        _amoutLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amoutLabel;
}


- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xA0AFC3) font:FONT_PINGFANG_X(13)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _statusLabel;
}

@end
