//
//  ZXSDInviteRecordsCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDInviteRecordsCell.h"

@interface ZXSDInviteItemCell ()

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *verifyLabel;
@property (nonatomic, strong) UILabel *wageLabel;
@property (nonatomic, strong) UILabel *withdrawLabel;


@end

@implementation ZXSDInviteItemCell

- (void)initView
{
    self.phoneLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(12)];
    self.verifyLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    self.verifyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.wageLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    self.wageLabel.textAlignment = NSTextAlignmentCenter;
    
    self.withdrawLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    self.withdrawLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.phoneLabel];
    [self.contentView addSubview:self.verifyLabel];
    [self.contentView addSubview:self.wageLabel];
    [self.contentView addSubview:self.withdrawLabel];
    
    CGFloat width = (SCREEN_WIDTH() - 40);
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(width * 0.25);
    }];
    
    [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(width * 0.25);
    }];
    
    [self.wageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(width * 0.25);
    }];
    
    [self.withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.wageLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(width * 0.25);
    }];
}

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDInviteItem class]]) {
        return;
    }
    
    ZXSDInviteItem *item = renderData;
    
    self.phoneLabel.text = item.phone;
    if (item.certifyAmount.integerValue == 0) {
        self.verifyLabel.text = @"-";
    } else {
        self.verifyLabel.text = [NSString stringWithFormat:@"¥%@", item.certifyAmount];
    }
    
    if (item.wageFlowAmount.integerValue == 0) {
        self.wageLabel.text = @"-";
    } else {
        self.wageLabel.text = [NSString stringWithFormat:@"¥%@", item.wageFlowAmount];
    }
    
    if (item.advanceAmount.integerValue == 0) {
        self.withdrawLabel.text = @"-";
    } else {
        self.withdrawLabel.text = [NSString stringWithFormat:@"¥%@", item.advanceAmount];
    }
    
}

@end

@interface ZXSDInviteRecordsCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *resultTable;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, strong) NSMutableArray<ZXSDInviteItem*> *totalRecords;

@end

@implementation ZXSDInviteRecordsCell

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[ZXSDInviteInfoModel class]]) {
        return;
    }
    
    ZXSDInviteInfoModel *info = renderData;
    
    self.descLabel.text = [NSString stringWithFormat:@"已邀请 %@ 个好友，共获得 ¥%@ 红包", @(info.totalRecommend), @(info.totalReward)];
}

- (void)setRecords:(NSArray *)records
{
    if (!records || records.count == 0) {
        self.emptyView.hidden = NO;
    } else {
        self.emptyView.hidden = YES;
        if (!_totalRecords) {
            self.totalRecords = [NSMutableArray arrayWithCapacity:records.count];
        } else {
            [self.totalRecords removeAllObjects];
        }
        
        [self.totalRecords addObjectsFromArray:records];
    }
    
    [self.resultTable reloadData];
}

- (void)initView
{
    UILabel *titleLab = [UILabel labelWithText:@"邀请记录" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(28)];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(20);
        make.top.inset(0);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *descLab = [UILabel labelWithText:@"已邀请 0 个好友，共获得 ¥0 红包" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
    [self.contentView addSubview:descLab];
    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.top.equalTo(titleLab.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
    }];
    self.descLabel = descLab;
    
    [self.contentView addSubview:self.resultTable];
    [self.resultTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLab.mas_bottom).offset(10);
        make.left.right.inset(0);
        make.height.mas_equalTo(44 * 6);
        make.bottom.inset(30);
    }];
    
    self.resultTable.tableFooterView = [UIView new];
    [self.resultTable registerClass:[ZXSDInviteItemCell class] forCellReuseIdentifier:[ZXSDInviteItemCell identifier]];
    
    [self.resultTable addSubview:self.emptyView];
    self.emptyView.backgroundColor = UIColor.redColor;
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.resultTable);
        make.width.mas_equalTo(SCREEN_WIDTH());
    }];
}

- (void)lookupMore
{
    if (self.moreAction) {
        self.moreAction();
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return MIN(self.totalRecords.count, 4);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXSDInviteItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSDInviteItemCell identifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZXSDInviteItem *model = [self.totalRecords objectAtIndex:indexPath.row];
    [cell setRenderData:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (self.totalRecords.count == 0) {
        return 0;
    }
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.totalRecords.count == 0) {
        return nil;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 44)];
    header.backgroundColor = UICOLOR_FROM_HEX(0xF8F8F8);
    
    UILabel *phoneLabel = [UILabel labelWithText:@"好友手机号" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(12)];
    
    UILabel *verifyLabel = [UILabel labelWithText:@"完成认证" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    verifyLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *wageLabel = [UILabel labelWithText:@"上传流水" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    wageLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *withdrawLabel = [UILabel labelWithText:@"成功预支" textColor:UICOLOR_FROM_HEX(0x666666) font:FONT_PINGFANG_X(12)];
    withdrawLabel.textAlignment = NSTextAlignmentCenter;
    
    [header addSubview:phoneLabel];
    [header addSubview:verifyLabel];
    [header addSubview:wageLabel];
    [header addSubview:withdrawLabel];
    
    CGFloat width = (SCREEN_WIDTH() - 40);
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(20);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    [verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    [wageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verifyLabel.mas_right);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    
    [withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-20);
        make.left.equalTo(wageLabel.mas_right);
        make.centerY.equalTo(header);
        make.width.mas_equalTo(width * 0.25);
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.totalRecords.count < 5) {
        return 0;
    }
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.totalRecords.count < 5) {
        return nil;
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), 44)];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIButton *more = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:@"查看更多" textColor:UICOLOR_FROM_HEX(0x999999)];
    [more addTarget:self action:@selector(lookupMore) forControlEvents:(UIControlEventTouchUpInside)];
    [footer addSubview:more];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footer).offset(20);
        make.right.equalTo(footer).offset(-20);
        make.top.bottom.equalTo(footer);
    }];
    
    return footer;
}

#pragma mark - Getter
- (UITableView *)resultTable
{
    if (!_resultTable) {
        _resultTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _resultTable.delegate = self;
        _resultTable.dataSource = self;
        _resultTable.showsVerticalScrollIndicator = NO;
        _resultTable.scrollEnabled = NO;
    }
    return _resultTable;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [UIView new];
        
        UIImageView *temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile_invite_empty"]];
        [_emptyView addSubview:temp];
        [temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_emptyView).offset(35);
            make.centerX.equalTo(_emptyView);
            make.width.mas_equalTo(98);
            make.height.mas_equalTo(120);
        }];
        
        UILabel *tips = [UILabel labelWithText:@"邀请记录为空" textColor:UICOLOR_FROM_HEX(0x999999) font:FONT_PINGFANG_X(14)];
        [_emptyView addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(temp.mas_bottom).offset(10);
            make.centerX.equalTo(_emptyView);
        
        }];
    }
    return _emptyView;
}

@end
