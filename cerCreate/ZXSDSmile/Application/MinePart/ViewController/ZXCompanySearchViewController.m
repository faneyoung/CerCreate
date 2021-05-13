//
//  ZXCompanySearchViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/12.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCompanySearchViewController.h"
#import <IQKeyboardManager.h>
#import "UITableView+help.h"
#import "UIViewController+help.h"

#import "EPNetworkManager.h"
#import "ZXCompanySearchModel.h"


@interface ZXCompanySearchViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation ZXCompanySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    self.title = @"填写企业名称";
    self.enableInteractivePopGesture = YES;
    
    [self.tableView registerClasses:@[
        NSStringFromClass(UITableViewCell.class),
    ]];
    
    [self adaptScrollView:self.tableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldValueChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

#pragma mark - data handle -
- (void)requestCompanyWithKeyword:(NSString *)keyword{
    if (!IsValidString(keyword)) {
        return;
    }
    
    if (keyword.length < 2) {
        return;
    }
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_searchByKeyWord parameters:@{@"keyWord":keyword} decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        if (error) {
            return;
        }
        
        self.searchResults = [ZXCompanySearchModel modelsWithData:response.resultModel.data];
        
        [self.tableView reloadData];
        
    }];
    
    
}

#pragma mark - views -

- (void)setupSubViews{
    
    UIView *headerView  = [[UIView alloc] init];
    headerView.backgroundColor = UIColor.whiteColor;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH(), 80);
    
    UIView *searchBarView = [[UIView alloc] init];
    searchBarView.backgroundColor = TextColorDisable;
    ViewBorderRadius(searchBarView, 20, 0.01, UIColor.whiteColor);
    [headerView addSubview:searchBarView];
    [searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(20);
    }];
    
    UIImageView *leftView = [[UIImageView alloc] initWithImage:UIImageNamed(@"icon_common_search")];
    leftView.contentMode = UIViewContentModeScaleAspectFill;
    [searchBarView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(15);
        make.centerY.offset(0);
    }];

    UITextField *tf = [[UITextField alloc] init];
    tf.font = FONT_PINGFANG_X(14);
    tf.textColor = TextColorTitle;
    tf.placeholder = @"请输入您的公司";
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeyDone;
    
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc] initWithString:tf.placeholder attributes:@{NSForegroundColorAttributeName : TextColor666666,NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0]}];
    tf.attributedPlaceholder = arrStr;
    [searchBarView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.mas_right).offset(10);
        make.top.bottom.inset(0);
        make.right.inset(15);
    }];
    self.textField = tf;
    
    self.tableView.tableHeaderView = headerView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 158;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - action -
- (void)backButtonClicked:(id)sender{
    if (IsValidString(self.textField.text) && self.completionBlock) {
        self.completionBlock(self.textField.text);
    }
    
    [super backButtonClicked:sender];
    
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = FONT_PINGFANG_X(14);
    cell.textLabel.textColor = TextColorTitle;
    
    ZXCompanySearchModel *model = self.searchResults[indexPath.row];
    
    cell.textLabel.attributedText = model.name;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.completionBlock) {
        ZXCompanySearchModel *searchModel = self.searchResults[indexPath.row];
        self.completionBlock(searchModel.companyName);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (IsValidString(self.textField.text) && self.completionBlock) {
        self.completionBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

#pragma mark - noti -

- (void)textfieldValueChange:(id)sender{

    UITextRange *selectedRange = self.textField.markedTextRange;
    UITextPosition *position = [self.textField positionFromPosition:selectedRange.start offset:0];
    
    if (!position) { // 没有高亮选择的字
        
        NSString *keyword = TrimString(self.textField.text);
        if (IsValidString(keyword)) {
            [self requestCompanyWithKeyword:keyword];
        }

    }else { //有高亮文字
        //do nothing
    }
}

@end
