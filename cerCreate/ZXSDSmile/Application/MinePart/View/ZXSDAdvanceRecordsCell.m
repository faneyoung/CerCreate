//
//  ZXSDAdvanceRecordsCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDAdvanceRecordsCell.h"

@interface ZXSDAdvanceRecordsCell()

@property (nonatomic, strong) UIView *loanStatusView;
@property (nonatomic, strong) UILabel *loanStatusLabel;
@property (nonatomic, strong) UILabel *loanAmountLabel;
@property (nonatomic, strong) UILabel *repaymentLabel;
@property (nonatomic, strong) UIButton *loanContractButton;

@end

@implementation ZXSDAdvanceRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.loanStatusView.layer.cornerRadius = 4.0;
    self.loanStatusView.layer.masksToBounds = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self.contentView addSubview:self.loanStatusView];
//    [self.contentView addSubview:self.repaymentLabel];
    [self.contentView addSubview:self.loanAmountLabel];
    [self.contentView addSubview:self.loanStatusLabel];
    [self.contentView addSubview:self.loanContractButton];
    
    [self.loanStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.top.bottom.inset(20);
        make.width.mas_equalTo(3);
    }];
    
//    [self.repaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.loanStatusView).offset(20);
//        make.centerY.equalTo(self.loanStatusView);
//    }];
//
//    [self.loanAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.repaymentLabel);
//        make.top.equalTo(self.repaymentLabel.mas_bottom).offset(8);
//        make.bottom.equalTo(self.contentView).offset(-20);
//    }];
    [self.loanAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.left.mas_equalTo(self.loanStatusView.mas_right).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    [self.loanContractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(self.loanAmountLabel);
    }];
    [self.loanStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loanAmountLabel);
        make.top.equalTo(self.loanAmountLabel.mas_bottom).inset(8);
        make.height.mas_equalTo(20);
        make.bottom.inset(20);

    }];
}


- (void)reloadSubviewsWithModel:(ZXSDAdvanceRecordsModel *)model {
    
    if ([model.loanStatus isEqualToString:@"PaidOff"] || [model.loanStatus isEqualToString:@"Canceled"]) {
        self.loanStatusView.backgroundColor = kThemeColorLine;
    } else {
        self.loanStatusView.backgroundColor = kThemeColorMain;
    }
    self.loanStatusLabel.text = model.loanStatusDes;
    
    // 已还款
    BOOL paidOff = [model.loanStatus isEqualToString:@"PaidOff"];
    if (!paidOff) {
//        self.repaymentLabel.text = [NSString stringWithFormat:@"扣款日 %@",model.repaymentDate];
//        self.repaymentLabel.textColor = UICOLOR_FROM_HEX(0x333333);
//        self.repaymentLabel.font = FONT_PINGFANG_X(16);
        
        self.loanAmountLabel.text = [NSString stringWithFormat:@"%@ 申请预支 ¥%@",model.loanDate, model.loanMoney];
        
        self.loanStatusLabel.hidden = NO;
        
        
    } else {
//        self.repaymentLabel.text = [NSString stringWithFormat:@"%@ 申请预支 ¥%@",model.loanDate, model.loanMoney];
//        self.repaymentLabel.textColor = UICOLOR_FROM_HEX(0x999999);
//        self.repaymentLabel.font = FONT_PINGFANG_X(14);
        
        self.loanAmountLabel.text = [NSString stringWithFormat:@"%@ 申请预支 ¥%@",model.loanDate, model.loanMoney];

        self.loanStatusLabel.text = [NSString stringWithFormat:@"%@ 已还款", model.repaymentDate];
        
        self.loanStatusLabel.hidden = NO;
    }
    
    if (model.isContractView) {
        self.loanContractButton.hidden = NO;
//        [self.loanStatusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.loanContractButton.mas_bottom).offset(10);
//
//        }];
        
    } else {
        self.loanContractButton.hidden = YES;
//        [self.loanStatusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(20.67);
//        }];
        
    }
}

- (void)loanContractButtonClicked:(id)sender
{
    if (self.jumpToLoanContractBlock) {
        self.jumpToLoanContractBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)loanStatusView
{
    if (!_loanStatusView) {
        _loanStatusView = [UIView new];
        _loanStatusView.layer.cornerRadius = 4.0;
        _loanStatusView.layer.masksToBounds = YES;
        
    }
    return _loanStatusView;
}

- (UILabel *)repaymentLabel
{
    if (!_repaymentLabel) {
        _repaymentLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    }
    return _repaymentLabel;
}

- (UILabel *)loanAmountLabel
{
    if (!_loanAmountLabel) {
        _loanAmountLabel = [UILabel labelWithText:@"" textColor:TextColorTitle font:FONT_PINGFANG_X(14)];
    }
    return _loanAmountLabel;
}

- (UILabel *)loanStatusLabel
{
    if (!_loanStatusLabel) {
        _loanStatusLabel = [UILabel labelWithText:@"" textColor:TextColorgray font:FONT_PINGFANG_X(14)];
    }
    return _loanStatusLabel;
}


- (UIButton *)loanContractButton
{
    if (!_loanContractButton) {
        _loanContractButton = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"合同" textColor:UICOLOR_FROM_HEX(0x999999)];
        [_loanContractButton setImage:[UIImage imageNamed:@"smile_mine_arrow"] forState:(UIControlStateNormal)];
        [_loanContractButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        [_loanContractButton setImageEdgeInsets:UIEdgeInsetsMake(0, 85, 0, 0)];
        [_loanContractButton addTarget:self action:@selector(loanContractButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loanContractButton;
}


@end


@interface ZXSDAdvanceRecordExtendCell ()

@property (nonatomic, strong) UIView *loanStatusView;
@property (nonatomic, strong) UILabel *loanStatusLabel;
@property (nonatomic, strong) UILabel *loanAmountLabel;
@property (nonatomic, strong) UILabel *repaymentLabel;
@property (nonatomic, strong) UIButton *loanContractButton;


@property (nonatomic, strong) UIView *extendView;
@property (nonatomic, strong) UIButton *extendBtn;
@property (nonatomic, strong) UIButton *infoBtn;
@property (nonatomic, strong) UIButton *repaymentBtn;

@end

@implementation ZXSDAdvanceRecordExtendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self.contentView addSubview:self.loanStatusView];
//    [self.contentView addSubview:self.repaymentLabel];
    [self.contentView addSubview:self.loanAmountLabel];
    [self.contentView addSubview:self.loanStatusLabel];
    [self.contentView addSubview:self.loanContractButton];
    [self.contentView addSubview:self.extendView];
    
    [self.loanStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.top.bottom.inset(20);
        make.width.mas_equalTo(3);
    }];
    
//    [self.repaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.loanStatusView).offset(20);
//        make.centerY.equalTo(self.loanStatusView);
//    }];
//
//    [self.loanAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.repaymentLabel);
//        make.top.equalTo(self.repaymentLabel.mas_bottom).offset(8);
//        //make.bottom.equalTo(self.contentView).offset(-20);
//    }];
    
    [self.loanAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.left.inset(39);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.loanContractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(self.loanAmountLabel);
    }];
    [self.loanStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loanAmountLabel);
        make.top.equalTo(self.loanAmountLabel.mas_bottom).inset(8);
        make.height.mas_equalTo(20);

    }];
    
    [self.extendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loanStatusLabel.mas_bottom).offset(11);
        make.left.equalTo(self.loanStatusLabel);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-18);
    }];
    
    [self.extendView addSubview:self.extendBtn];
    [self.extendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.extendView);
        make.width.mas_equalTo(60);
    }];
    
    [self.extendView addSubview:self.infoBtn];
    [self.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.extendBtn.mas_right).offset(8);
        make.height.width.mas_equalTo(14);
        make.centerY.equalTo(self.extendBtn);
    }];
    
    UIView *vline = [UIView new];
    vline.backgroundColor = UICOLOR_FROM_HEX(0xE5E5E5);
    [self.extendView addSubview:vline];
    [vline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoBtn.mas_right).offset(15);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.extendView addSubview:self.repaymentBtn];
    [self.repaymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.extendView);
        make.left.equalTo(vline.mas_right).offset(15);
        make.width.mas_equalTo(60);
        //make.height.mas_equalTo(20);
    }];
}

- (void)repaymentLoan
{
    if (self.repaymentAction) {
        self.repaymentAction();
    }
}

- (void)doExtendAction
{
    if (self.extendAction) {
        self.extendAction();
    }
}

- (void)showExtendAlert
{
    if (self.extendAlert) {
        self.extendAlert();
    }
}

- (void)reloadSubviewsWithModel:(ZXSDAdvanceRecordsModel *)model {
    
    if ([model.loanStatus isEqualToString:@"PaidOff"] || [model.loanStatus isEqualToString:@"Canceled"]) {
        self.loanStatusView.backgroundColor = kThemeColorLine;
    } else {
        self.loanStatusView.backgroundColor = kThemeColorMain;
    }
    self.loanStatusLabel.text = model.loanStatusDes;
    
    // 已还款
    BOOL paidOff = [model.loanStatus isEqualToString:@"PaidOff"];
    if (!paidOff) {
        self.repaymentLabel.text = [NSString stringWithFormat:@"扣款日 %@",model.repaymentDate];
        self.repaymentLabel.textColor = UICOLOR_FROM_HEX(0x333333);
        self.repaymentLabel.font = FONT_PINGFANG_X(16);
        
        self.loanAmountLabel.text = [NSString stringWithFormat:@"%@ 申请预支 ¥%@",model.loanDate, model.loanMoney];
        
        self.loanStatusLabel.hidden = NO;
        
        
    } else {
        self.repaymentLabel.text = [NSString stringWithFormat:@"%@ 申请预支 ¥%@",model.loanDate, model.loanMoney];
        self.repaymentLabel.textColor = UICOLOR_FROM_HEX(0x999999);
        self.repaymentLabel.font = FONT_PINGFANG_X(14);
        
        self.loanAmountLabel.text = [NSString stringWithFormat:@"%@ 已还款", model.repaymentDate];
        
        self.loanStatusLabel.hidden = YES;
    }
    
    if (model.isContractView) {
        self.loanContractButton.hidden = NO;
    } else {
        self.loanContractButton.hidden = YES;
    }
    
    // 展期按钮逻辑
    ZXSDAdvanceExtendModel *extendInfo = model.extendButton;
    [self.extendBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    if (extendInfo.enable) {
        
        UIColor *color = nil;
        // 已展期
        if ([extendInfo.action isEqualToString:@"VIEW_EXTEND"]) {
            color = UICOLOR_FROM_HEX(0x999999);
            [_extendBtn addTarget:self action:@selector(showExtendAlert) forControlEvents:(UIControlEventTouchUpInside)];
            
        } else if ([extendInfo.action isEqualToString:@"APPLY_EXTEND"]){
            color = UICOLOR_FROM_HEX(0x00B050);
            [_extendBtn addTarget:self action:@selector(doExtendAction) forControlEvents:(UIControlEventTouchUpInside)];
            
        }
        
        [self.extendBtn setTitleColor:color forState:(UIControlStateNormal)];
        
    } else { // 已逾期
        [self.extendBtn setTitleColor:UICOLOR_FROM_HEX(0xFF4C00) forState:(UIControlStateNormal)];
    }
    
    [self.extendBtn setTitle:extendInfo.title forState:(UIControlStateNormal)];
    CGFloat width = [extendInfo.title boundingRectWithSize:CGSizeMake(200, 30) options:0 attributes:@{NSFontAttributeName:FONT_PINGFANG_X(14)} context:nil].size.width;
    [self.extendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width + 10);
    }];
    
    BOOL showInfo = false;
    if (extendInfo.enable && [extendInfo.action isEqualToString:@"VIEW_EXTEND"]) {
        showInfo = true;
    }
    [self.infoBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(showInfo?14:0);
        make.left.equalTo(self.extendBtn.mas_right).offset(showInfo?8:0);
    }];
    
    self.infoBtn.hidden = !showInfo;

}

- (void)loanContractButtonClicked:(id)sender
{
    if (self.jumpToLoanContractBlock) {
        self.jumpToLoanContractBlock();
    }
}


#pragma mark - Getter

- (UIView *)extendView
{
    if (!_extendView) {
        _extendView = [UIView new];
        _extendView.clipsToBounds = YES;
        _extendView.backgroundColor = [UIColor whiteColor];
    }
    return _extendView;
}

- (UIButton *)extendBtn
{
    if (!_extendBtn) {
        _extendBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"展期" textColor:UICOLOR_FROM_HEX(0x00B050)];
    }
    return _extendBtn;
}

- (UIButton *)repaymentBtn
{
    if (!_repaymentBtn) {
        _repaymentBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"立刻还款" textColor:UICOLOR_FROM_HEX(0x00B050)];
        [_repaymentBtn addTarget:self action:@selector(repaymentLoan) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _repaymentBtn;
}

- (UIButton *)infoBtn
{
    if (!_infoBtn) {
        _infoBtn = [UIButton buttonWithNormalImage:UIIMAGE_FROM_NAME(@"smile_info_icon") highlightedImage:nil];
        [_infoBtn addTarget:self action:@selector(showExtendAlert) forControlEvents:(UIControlEventTouchUpInside)];
        _infoBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-15, -20, -15, -20);
    }
    return _infoBtn;
}

- (UIView *)loanStatusView
{
    if (!_loanStatusView) {
        _loanStatusView = [UIView new];
        _loanStatusView.layer.cornerRadius = 4.0;
        _loanStatusView.layer.masksToBounds = YES;
        
    }
    return _loanStatusView;
}

- (UILabel *)repaymentLabel
{
    if (!_repaymentLabel) {
        _repaymentLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    }
    return _repaymentLabel;
}

- (UILabel *)loanAmountLabel
{
    if (!_loanAmountLabel) {
        _loanAmountLabel = [UILabel labelWithText:@"" textColor:TextColorTitle font:FONT_PINGFANG_X(14)];
    }
    return _loanAmountLabel;
}

- (UILabel *)loanStatusLabel
{
    if (!_loanStatusLabel) {
        _loanStatusLabel = [UILabel labelWithText:@"" textColor:TextColorgray font:FONT_PINGFANG_X(14)];
    }
    return _loanStatusLabel;
}


- (UIButton *)loanContractButton
{
    if (!_loanContractButton) {
        _loanContractButton = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"合同" textColor:UICOLOR_FROM_HEX(0x999999)];
        [_loanContractButton setImage:[UIImage imageNamed:@"smile_mine_arrow"] forState:(UIControlStateNormal)];
        [_loanContractButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        [_loanContractButton setImageEdgeInsets:UIEdgeInsetsMake(0, 85, 0, 0)];
        [_loanContractButton addTarget:self action:@selector(loanContractButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loanContractButton;
}


@end
