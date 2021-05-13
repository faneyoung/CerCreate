//
//  ZXTaskCenterViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/18.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskCenterViewController.h"
#import "UIViewController+help.h"
#import "UITableView+help.h"

//views
#import "ZXTaskCenterTitleCell.h"
#import "ZXTaskCenterHeaderView.h"
#import "ZXTaskCenterItemCell.h"
#import "ZXAmountEvaluateRefCell.h"
#import "ZXMallGoodsFooterView.h"


#import "ZXLocationManager.h"

#import "EPNetworkManager.h"
#import "ZXTaskCenterModel.h"
#import "ZXSDUserDefaultHelper.h"
#import "ZXVerifyStatusModel.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeNeeded,
    SectionTypeReference,
    SectionTypeAwarded,
    SectionTypeAll
};

#define pictureHeight       116+kStatusBarHeight

@interface ZXTaskCenterViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *customNavView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, assign) BOOL showBlackStatusBar;

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) ZXTaskCenterHeaderView *headerView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *taskCenters;

@property (nonatomic, strong) NSDictionary *locationDic;

@property (nonatomic, strong) ZXTaskCenterModel *neededTask;
@property (nonatomic, strong) ZXTaskCenterModel *refTask;
@property (nonatomic, strong) ZXTaskCenterModel *awardedTask;

@property (nonatomic, strong) ZXVerifyStatusModel *statusModel;

@end

@implementation ZXTaskCenterViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:kNotificationRefreshTaskCenter object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHideNavigationBar = YES;
    [self adaptScrollView:self.tableView];
    self.view.backgroundColor = kThemeColorBg;

    [self.tableView registerNibs:@[
        NSStringFromClass(ZXTaskCenterItemCell.class),
        NSStringFromClass(ZXTaskCenterTitleCell.class),
        NSStringFromClass(ZXAmountEvaluateRefCell.class),
    ]];
    
//    [self testBtnAction:^(UIButton * _Nonnull btn) {
//        [URLRouter routerUrlWithPath:kRouter_amountEvaluation extra:nil];
//    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requsetTaskItems];
    [self requestFourStepStatus];
    
}



#pragma mark - views -
- (void)setupSubViews{
    

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.inset(0);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(pictureHeight, 0, 0, 0);
    //设置"tableHeaderView", 在头视图上添加ImageView;
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH(), pictureHeight)];
    [self.header addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    [self.tableView addSubview:self.header];
    
    [self.view addSubview:self.customNavView];
    [self.customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(kNavigationBarHeight);
    }];
    
}

- (ZXTaskCenterHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [ZXTaskCenterHeaderView instanceMineHeaderView];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kThemeColorBg;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 158;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        
    }
    return _tableView;
}


- (UIView *)customNavView{
    if (!_customNavView) {
        UIView *customNavBarView = [[UIView alloc] init];
        customNavBarView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
        UILabel *lab = [[UILabel alloc] init];
        lab.font = FONT_PINGFANG_X_Medium(17);
        lab.textColor = UIColor.whiteColor;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"任务中心";
        [customNavBarView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.inset(0);
            make.height.mas_equalTo(kNavigationBarNormalHeight);
        }];
        self.titleLab = lab;
        
        _customNavView = customNavBarView;
    }
    
    return _customNavView;
}


#pragma mark - data handle -

- (void)refreshAllData{
    [self requsetTaskItems];
    [self requestFourStepStatus];
}

- (void)requsetTaskItems {
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_taskCenter parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();

        if([self handleError:error response:response]){
            return;
        }

        self.taskCenters = [ZXTaskCenterModel modelsWithData:response.resultModel.data];
        
        self.neededTask = nil;
        self.refTask = nil;
        self.awardedTask = nil;
        [self.taskCenters enumerateObjectsUsingBlock:^(ZXTaskCenterModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.titleCode isEqualToString:@"necessary"]) {
                self.neededTask = obj;
            }
            else if ([obj.titleCode isEqualToString:@"refer"]) {
                self.refTask = obj;
            }
            else if ([obj.titleCode isEqualToString:@"other"]) {
                self.awardedTask = obj;
            }
        }];


        [self.tableView reloadData];
        
        
    }];
}

- (void)requestFourStepStatus{
    
    LoadingManagerShow();
    [[EPNetworkManager defaultManager] getAPI:kPath_verifyStatus parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            return;
        }
        
        self.statusModel = [ZXVerifyStatusModel instanceWithDictionary:response.originalContent];
    }];
}


- (void)uploadLocationInfomation {
    if (!IsValidDictionary(self.locationDic)) {
        return;
    }

    LoadingManagerShow();
    [EPNetworkManager.defaultManager postAPI:kPath_uploadLocation parameters:self.locationDic decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        if (error) {
            [self handleRequestError:error];
            return;
        }
        NSLog(@"---------upload loc result=%@",((NSDictionary*)response.originalContent).modelToJSONString);
        
        [self requsetTaskItems];
        
    }];
}


- (ZXTaskCenterModel*)taskWithSection:(NSInteger)section{
    ZXTaskCenterModel *task = nil;
    if (section == SectionTypeNeeded) {
        task = self.neededTask;
    }
    else if(section == SectionTypeReference){
        task = self.refTask;
    }
    else if(section == SectionTypeAwarded){
        task = self.awardedTask;
    }
    return task;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.taskCenters.count;
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (!IsValidArray(self.taskCenters)) {
        return 0;
    }
    
    if (section == SectionTypeReference) {
        if (IsValidArray(self.refTask.taskItems)) {
            return 2;
        }
        return 0;
    }
    
    ZXTaskCenterModel *task = [self taskWithSection:section];
    

    return task.taskItems.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXTaskCenterModel *task = [self taskWithSection:indexPath.section];

    if (indexPath.section == SectionTypeReference) {
        
        if (indexPath.row == 0) {
            ZXTaskCenterTitleCell *cell =  [ZXTaskCenterTitleCell instanceCell:tableView];
            [cell updateViewsWithData:task.titleDesc];

            cell.isFirstRow = indexPath.section == 0;
            cell.customTitleView = YES;
            return cell;
        }

        ZXAmountEvaluateRefCell *cell = [ZXAmountEvaluateRefCell instanceCell:tableView];
        [cell updateWithData:task.taskItems];
        cell.hideTopView = YES;
        return cell;
    }

    if (indexPath.row == 0) {
        ZXTaskCenterTitleCell *cell =  [ZXTaskCenterTitleCell instanceCell:tableView];
        [cell updateViewsWithData:task.titleDesc];

        cell.isFirstRow = indexPath.section == 0;
        
        return cell;
    }
    

    

//    ZXTaskCenterItemCell *cell = [ZXTaskCenterItemCell instanceCell:tableView];
    
    ZXTaskCenterItemCell *cell = [ZXTaskCenterItemCell instanceCell:tableView];

    [cell updateWithData:task.taskItems[indexPath.row-1]];
    cell.isBottom = indexPath.row == (task.taskItems.count);
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == SectionTypeAll-1) {
        return 162;
    }

    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == SectionTypeAll-1) {
        ZXMallGoodsFooterView *footer = [[ZXMallGoodsFooterView alloc] init];
        footer.backgroundColor = kThemeColorBg;
        return footer;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return;
    }
    
    ZXTaskCenterModel *task = [self taskWithSection:indexPath.section];
    
    if ([task.titleCode isEqualToString:@"refer"]) {
        return;
    }
    
    ZXTaskCenterItem *item = task.taskItems[indexPath.row-1];
    if ([item.certKey isEqualToString:@"identity"]) {//身份认证
        
        if ([item.action isEqualToString:@"idCardVerify"]) {
            [URLRouter routerUrlWithPath:kRouter_idCardUpload extra:@{@"backViewController":self}];
        }
        else if([item.action isEqualToString:@"faceVerify"]){
            [URLRouter routerUrlWithPath:kRouter_liveFace extra:@{@"backViewController":self}];
        }


        return;
    }

    
    if (self.statusModel) {
        
        if (!self.statusModel.bankCardDone) {
            [URLRouter routerUrlWithPath:kRouter_bindCard extra:nil];
            return;
        }
        
        if (!self.statusModel.jobInfoDone) {
            [URLRouter routerUrlWithPath:kRouter_bindEmployerInfo extra:nil];

            return;
        }
    }
    

    
    if([item.certKey isEqualToString:@"salaryInfo"]){
        if ([item.certStatus isEqualToString:@"NotDone"] ||
            [item.certStatus isEqualToString:@"Expired"]) {
            
            [URLRouter routerUrlWithPath:kRouter_salaryInfo extra:@{@"certType":item.certKey}];
            
        }
        else{
            NSMutableDictionary *tmps = @{}.mutableCopy;
            [tmps setSafeValue:item.certKey forKey:@"certType"];
            [tmps setSafeValue:item.certStatus forKey:@"certStatus"];
            [tmps setSafeValue:item.certContent forKey:@"failureDesc"];

            [URLRouter routerUrlWithPath:kRouter_uploadDetailResult extra:tmps.copy];
        }

    }
    else if([item.certKey isEqualToString:@"consumeInfo"]){
        if ([item.certStatus isEqualToString:@"NotDone"] ||
            [item.certStatus isEqualToString:@"Expired"]) {
            
            [URLRouter routerUrlWithPath:kRouter_consumeInfo extra:@{@"certType":item.certKey}];
        }
        else{
            
            NSMutableDictionary *tmps = @{}.mutableCopy;
            [tmps setSafeValue:item.certKey forKey:@"certType"];
            [tmps setSafeValue:item.certStatus forKey:@"certStatus"];
            [tmps setSafeValue:item.certContent forKey:@"failureDesc"];

            [URLRouter routerUrlWithPath:kRouter_uploadDetailResult extra:tmps.copy];
        }


    }
    else if([item.certKey isEqualToString:@"assessmentLimit"]){//额度评估
        [URLRouter routerUrlWithPath:kRouter_amountEvaluation extra:nil];
    }
    else if ([item.certKey isEqualToString:@"geographicInfo"]) {
            TrackEvent(kLocation);
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self getLocationPermission];
//            });
        
        [self requestUploadLocationWithLocation];
        
        }
    else if([item.certKey isEqualToString:@"wechantInfo"] ||
            [item.certKey isEqualToString:@"wxCompanyInfo"]){
        [URLRouter routerUrlWithPath:GetString(item.url) extra:nil];
    }
    else if([item.certKey isEqualToString:@"workUnit"]){
        [URLRouter routerUrlWithPath:kRouter_companyInfo extra:nil];
    }
    else{
        [URLRouter routerUrlWithPath:item.certKey extra:nil];
    }
    
}

#pragma mark - UIScrollViewDelegate -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.showBlackStatusBar) {
        self.titleLab.textColor = TextColorTitle;
        return UIStatusBarStyleDefault;
    }
    else{
        self.titleLab.textColor = UIColor.whiteColor;
        return UIStatusBarStyleLightContent;

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

  //获取到下拉或上拉的偏移量,这里的偏移量是纵向从contentInset算起,即一开始偏移量就是0,向下拉为负,上拉为正;
    CGPoint point = scrollView.contentOffset;
    if (point.y < -pictureHeight) {
        CGRect rect = CGRectMake(0, point.y, SCREEN_WIDTH(), -point.y);
        self.header.frame = rect;
        [self.headerView.pictureImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(rect.size.height);
        }];
        
        [self.header layoutIfNeeded];
        [self.view layoutIfNeeded];
    }
    
    CGFloat offsetY = scrollView.contentOffset.y+pictureHeight;
    if (offsetY <= 0) {
        self.customNavView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
        self.titleLab.textColor = UIColor.whiteColor;
        return;
    }
    CGFloat alpha = fabs(offsetY/kNavigationBarHeight);
    alpha = alpha > 1 ? 1 : alpha;
    alpha = alpha < 0 ? 0 : alpha;
//    NSLog(@"----------alpha=%.2f",alpha);

    self.customNavView.backgroundColor = UIColorHexAlpha(0xffffff, alpha);

    self.showBlackStatusBar = alpha >= 0.8;
    [self setNeedsStatusBarAppearanceUpdate];


}


#pragma mark - Location

- (void)requestUploadLocationWithLocation{
    LoadingManagerShow();
    @weakify(self);
    [ZXLocationManager.sharedManger startLocationWithSuccessBlock:^(NSDictionary * _Nonnull loc) {
        @strongify(self);
        LoadingManagerHidden();
        self.locationDic = loc;
        [self uploadLocationInfomation];
    } failureBlock:^(NSError * _Nonnull error) {
        LoadingManagerHidden();
//            @"正在获取位置信息请稍后再试"
        [self uploadLocationInfomation];

    }];
}

@end
