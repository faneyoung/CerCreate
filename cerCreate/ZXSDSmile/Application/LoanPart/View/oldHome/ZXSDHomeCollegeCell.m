//
//  ZXSDHomeCollegeCell.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/8/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDHomeCollegeCell.h"
#import "TYCyclePagerView.h"
#import "NSURL+QueryDictionary.h"

@interface ZXSDCollegeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UIImageView *icon;

- (void)configData:(ZXSDHomeCollegeModel *)model;

@end

@implementation ZXSDCollegeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)configData:(ZXSDHomeCollegeModel *)model
{
    self.backgroundColor = UICOLOR_FROM_HEX(model.hexColor);
    self.titleLabel.text = model.title;
    self.detailBtn.backgroundColor = UICOLOR_FROM_HEX(model.btnColor);
    
    self.icon.image = UIIMAGE_FROM_NAME(model.iconName);
}

- (void)initUI
{
    self.layer.cornerRadius = 8;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailBtn];
    [self.contentView addSubview:self.icon];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(14);
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.bottom.equalTo(self.contentView).offset(-74);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(32);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(69);
        make.height.mas_equalTo(54);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:@"" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(14)];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIButton *)detailBtn
{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(12) title:@"查看详情" textColor:UICOLOR_FROM_HEX(0xFFFFFF)];
        _detailBtn.layer.cornerRadius = 16;
        _detailBtn.userInteractionEnabled = NO;
    }
    return _detailBtn;
}

- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_college_icon"]];
    }
    return _icon;
}

@end



@interface ZXSDHomeCollegeCell ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;

@end


@implementation ZXSDHomeCollegeCell

- (void)setRenderData:(id)renderData
{
    if (![renderData isKindOfClass:[NSArray class]]) {
        return;
    }
    self.colleges = renderData;
    [self.pagerView reloadData];
}

- (void)initView
{
    UILabel *titleLabel = [UILabel labelWithText:@"薪朋友学院" textColor:UICOLOR_FROM_HEX(0x333333) font:FONT_PINGFANG_X(20)];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.contentView addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(180);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView
{
    return self.colleges.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{    
    ZXSDCollegeCollectionCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"collegeCell" forIndex:index];
    
    ZXSDHomeCollegeModel *model = [self.colleges objectAtIndex:index];
    [cell configData:model];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView
{
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(160, 180);
    layout.itemSpacing = 15;
    layout.itemHorizontalCenter = NO;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    ZXSDHomeCollegeModel *model = [self.colleges objectAtIndex:index];
    if (self.showDetail) {
        self.showDetail(model.detailURL);
    }
    
    if (IsValidString(model.detailURL)) {
      NSDictionary *dic =  ((NSURL*)(model.detailURL.URLByCheckCharacter)).uq_queryDictionary;
        if (IsValidDictionary(dic)) {
            [ZXAppTrackManager event:ksalaryFriendAcademyPage extra:@{@"type":[dic stringObjectForKey:@"type"]}];
        }
    }
    
}

#pragma mark - Getter
- (TYCyclePagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc] init];
        _pagerView.isInfiniteLoop = NO;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        
        [_pagerView registerClass:[ZXSDCollegeCollectionCell class] forCellWithReuseIdentifier:@"collegeCell"];
    }
    return _pagerView;
}

@end


