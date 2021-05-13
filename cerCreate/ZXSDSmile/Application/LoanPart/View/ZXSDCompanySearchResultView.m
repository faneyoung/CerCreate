//
//  ZXSDCompanySearchResultView.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/15.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDCompanySearchResultView.h"

@interface ZXSDCompanySearchResultView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *resultTable;

@property (nonatomic, strong) NSMutableArray<ZXSDCompanyModel*> *result;

@end

@implementation ZXSDCompanySearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.result = [NSMutableArray new];
    }
    return self;
}


- (void)initView
{
    self.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.resultTable];
    [self.resultTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"companyInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    ZXSDCompanyModel *model = [self.result objectAtIndex:indexPath.row];
    cell.textLabel.font = FONT_PINGFANG_X(14);
    cell.textLabel.text = model.companyName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectModel) {
        ZXSDCompanyModel *model = [self.result objectAtIndex:indexPath.row];
        self.didSelectModel(model);
    }
}

- (void)freshResultWithResults:(NSArray<ZXSDCompanyModel*> *)data
{
    self.result = [NSMutableArray arrayWithArray:data];
    [self.resultTable reloadData];
}

- (UITableView *)resultTable
{
    if (!_resultTable) {
        _resultTable = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _resultTable.delegate = self;
        _resultTable.dataSource = self;
    }
    return _resultTable;
}


@end
