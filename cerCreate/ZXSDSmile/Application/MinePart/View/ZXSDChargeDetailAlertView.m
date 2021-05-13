//
//  ZXSDChargeDetailAlertView.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDChargeDetailAlertView.h"

@interface ZXSDChargeDetailAlertView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *data;

@end

@implementation ZXSDChargeDetailAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUserInterfaceConfigure];
    }
    return self;
}

- (void)configWithData:(NSArray *)data
{
    self.data = data;
    [self.mainTable reloadData];
}

- (void)addUserInterfaceConfigure
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12.0;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.mainTable];
    [self addSubview:self.confirmButton];
    
    self.titleLab = [UILabel labelWithText:@"费用明细" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-40);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.mainTable registerClass:[ZXSDChargeDetailAlertCell class] forCellReuseIdentifier:@"chargeCell"];
    
}

- (void)confirmButtonClicked
{
    if (self.confirmAction) {
        self.confirmAction();
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chargeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *item = [self.data objectAtIndex:indexPath.row];
    
    ZXSDChargeDetailAlertCell *chareCell = (ZXSDChargeDetailAlertCell *)cell;
    chareCell.keyLabel.text = item[@"key"];
    chareCell.valueLabel.text = item[@"value"];
    
    [cell showBottomLine];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

#pragma mark - Getter

- (UILabel *)ruleLabel
{
    UILabel *rule = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
    rule.numberOfLines = 2;
    return rule;
}

- (UITableView *)mainTable
{
    if (!_mainTable) {
        _mainTable = [UITableView new];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.estimatedRowHeight = 50;
        _mainTable.backgroundColor = UIColor.whiteColor;

    }
    return _mainTable;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_confirmButton setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:(UIControlStateNormal)];
        [_confirmButton setTitleColor:UICOLOR_FROM_HEX(0xFFFFFF) forState:UIControlStateNormal];
        
        [_confirmButton setTitle:@"知道了" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 22.0;
        _confirmButton.layer.masksToBounds = YES;
        
    }
    return _confirmButton;
}

@end


@implementation ZXSDChargeDetailAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.keyLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:self.keyLabel];
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    self.valueLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keyLabel.mas_right).offset(20);
        make.top.bottom.equalTo(self.keyLabel);
    }];
    
}

@end
