//
//  ZXSDChooseEmployerCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/14.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDChooseEmployerCell.h"
#import "ZXSDCompanyModel.h"

@interface ZXSDChooseEmployerCell ()

@property (nonatomic, strong) UIImageView *companyIcon;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *charLabel;

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIImageView *shitImageView;

@property (nonatomic, strong) UIView *container;

@end

@implementation ZXSDChooseEmployerCell

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDCompanyModel class]]) {
        return;
    }
    
    ZXSDCompanyModel *model = renderData;
    self.companyName.text = model.shortName;
    
    if (model.logoUrl.length > 0 ) {
        if ([model.logoUrl hasPrefix:@"http"]) {
            [self.companyIcon sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
        } else {
            self.companyIcon.image = [UIImage imageNamed:model.logoUrl];
        }
        
        self.charLabel.hidden = YES;
    } else {
        self.charLabel.hidden = NO;
        
        if ([model.companyRefId isEqualToString:@"0000"]){
            self.charLabel.text = @"···";
            self.charLabel.layer.mask = nil;
            self.charLabel.layer.cornerRadius = 12;
        } else {
            self.charLabel.text = [self transformToPinyin:model.shortName];
            
            UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.charLabel.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4.0, 4.0)];
            CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
            cornerRadiusLayer.frame = self.charLabel.bounds;
            cornerRadiusLayer.path = cornerRadiusPath.CGPath;
            self.charLabel.layer.mask = cornerRadiusLayer;
            self.charLabel.layer.cornerRadius = 0;
        }
        
        if (self.indexPath.row % 2 == 0) {
            self.charLabel.backgroundColor = kThemeColorMain;
        } else {
            self.charLabel.backgroundColor = UICOLOR_FROM_HEX(0X5886E2);
        }
    }
    
    if (model.selecteStatus) {
        self.container.backgroundColor = UICOLOR_FROM_HEX(0xECF5FF);
        self.shitImageView.image = [UIImage imageNamed:@"choose_employer_highlighted"];
    } else {
        self.container.backgroundColor = UICOLOR_FROM_HEX(0xF7F7F7);
        self.shitImageView.image = [UIImage imageNamed:@"choose_employer_normal"];
    }
    self.checkBtn.selected = model.selecteStatus;
    
}

- (void)initView
{
    UIView *container = self.contentView;
    
    [container addSubview:self.companyName];
    [container addSubview:self.checkBtn];
    
    
    [container addSubview:self.companyIcon];
    [self.companyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(container);
        make.left.equalTo(container).offset(20);
        
    }];
    
    [container addSubview:self.charLabel];
    [self.charLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(container);
        make.left.equalTo(container).offset(20);
    }];
    
    
    
    [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyIcon.mas_right).offset(16);
        make.centerY.equalTo(self.companyIcon);
        make.right.equalTo(self.checkBtn.mas_left).offset(-16);
        
    }];
    
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(container).offset(-20);
        make.centerY.equalTo(self.companyIcon);
        make.width.height.mas_equalTo(24);
    }];
}

- (NSString *)transformToPinyin:(NSString *)source
{
    NSMutableString *str = [NSMutableString stringWithString:source];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);

    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
}

- (UIImageView *)companyIcon
{
    if (!_companyIcon) {
        _companyIcon = [UIImageView new];
        _companyIcon.backgroundColor = [UIColor whiteColor];
        _companyIcon.layer.cornerRadius = 12;
        //_companyIcon.clipsToBounds = YES;
        _companyIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _companyIcon;
}

- (UILabel *)charLabel
{
    if (!_charLabel) {
        _charLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0xFFFFFF) font:FONT_PINGFANG_X(14)];
        _charLabel.frame = CGRectMake(0, 0, 24, 24);
        _charLabel.textAlignment = NSTextAlignmentCenter;
        _charLabel.backgroundColor = kThemeColorMain;
        //_charLabel.layer.cornerRadius = 12;
        _charLabel.clipsToBounds = YES;
    }
    return _charLabel;
}

- (UILabel *)companyName
{
    if (!_companyName) {
        _companyName = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x3C465A) font:FONT_PINGFANG_X(14)];
    }
    return _companyName;
}

- (UIButton *)checkBtn
{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"choose_employer_uncheck"] highlightedImage:nil];
        [_checkBtn setImage:[UIImage imageNamed:@"choose_employer_checked"] forState:(UIControlStateSelected)];
        _checkBtn.userInteractionEnabled = NO;
    }
    return _checkBtn;
}

- (UIImageView *)shitImageView
{
    if (!_shitImageView) {
        _shitImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_employer_normal"]];
    }
    return _shitImageView;
}

@end
