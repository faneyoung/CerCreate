//
//  ZXSDPersonalCenterCell.m
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/12.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDPersonalCenterCell.h"

@interface ZXSDPersonalCenterCell()

//@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, strong) UIView *dotView;

@end

@implementation ZXSDPersonalCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.contentLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(24);
        //make.centerY.mas_equalTo(0);
        make.centerY.equalTo(self.contentView).offset(5);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(20);
        make.centerY.equalTo(self.logoImageView);
    }];
    
    UIImageView *indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_mine_arrow"]];
    [self.contentView addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.width.height.mas_equalTo(16);
        make.centerY.equalTo(self.logoImageView);
    }];
    //self.accessoryView = indicatorView;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.contentView addSubview:self.dotView];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(35);
        make.centerY.offset(5);
        make.width.height.mas_equalTo(6);
    }];
    self.dotView.hidden = YES;
}

- (void)reloadSubviewsWithModel:(ZXPersonalCenterModel *)model {
    self.logoImageView.image = UIIMAGE_FROM_NAME(model.icon);
    
    self.contentLabel.text = model.title;
    
    if ([model.title isEqualToString:@"优惠券"]) {
        self.dotView.hidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"kCouponRedDotkey"];
        
    }
    
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
    }
    return _logoImageView;
}

- (UIView *)dotView{
    if (!_dotView) {
        _dotView = [[UIView alloc] init];
        _dotView.backgroundColor = kThemeColorRed;
        ViewBorderRadius(_dotView, 3, 0.01, kThemeColorRed);
    }
    return _dotView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(16)];
    }
    return _contentLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
