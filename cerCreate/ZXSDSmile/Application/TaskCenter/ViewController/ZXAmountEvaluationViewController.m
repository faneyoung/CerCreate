//
//  ZXAmountEvaluationViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/9.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmountEvaluationViewController.h"

#import "UIViewController+help.h"
#import "UITableView+help.h"
#import "EPNetworkManager.h"

//vc
#import "ZXResultNoteViewController.h"


//views
#import "ZXAmountInfoCell.h"
#import "ZXTaskCenterItemCell.h"
#import "ZXAmountEvaluateRefCell.h"


#import "ZXAmountEvaluateListModel.h"

typedef NS_ENUM(NSUInteger, SectionType) {
    SectionType300,
    SectionType500,
    SectionTypeAll
};

@interface ZXAmountEvaluationViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *evaluateList;

@end

@implementation ZXAmountEvaluationViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllData) name:kNotificationRefreshAmountEvaluate object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"额度资格评估";
    self.enableInteractivePopGesture = YES;

    [self.tableView registerNibs:@[
        NSStringFromClass(ZXAmountInfoCell.class),
        NSStringFromClass(ZXAmountEvaluateRefCell.class),
        NSStringFromClass(ZXTaskCenterItemCell.class),

    ]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requsetTaskItems];
}

#pragma mark - data handle -
- (void)refreshAllData{
    [self requsetTaskItems];
}

- (void)requsetTaskItems {
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    [tmps setSafeValue:@"iOS" forKey:@"model"];
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] getAPI:kPath_amountEvaluateInfo parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        LoadingManagerHidden();
        
        if ([self handleError:error response:response]) {
            return;
        }

        self.evaluateList = [ZXAmountEvaluateListModel modelsWithData:response.resultModel.data];
        
        [self.tableView reloadData];
    }];
}

- (NSArray*)scoreItemsWithModel:(ZXAmountEvaluateListModel*)listModel{
    __block NSMutableArray *scores = [NSMutableArray arrayWithCapacity:2];
    [listModel.taskItems enumerateObjectsUsingBlock:^(ZXTaskCenterItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.certKey isEqualToString:@"referScoreSesame"]) {
            [scores insertObject:obj atIndex:0];
        }
        else if([obj.certKey isEqualToString:@"referScoreWechat"]){
            [scores insertObject:obj atIndex:1];
        }
    }];

    return scores.copy;
}

- (ZXTaskCenterItem*)incomeDetailItem{
    __block ZXTaskCenterItem *item = nil;
    [self.evaluateList enumerateObjectsUsingBlock:^(ZXAmountEvaluateListModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.taskItems enumerateObjectsUsingBlock:^(ZXTaskCenterItem*  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if ([obj1.certKey isEqualToString:@"bankIncomeDetails"]) {
                item = obj1;
                *stop = YES;
            }
        }];
    }];
    return item;
}

#pragma mark - views -
- (void)setupSubViews{

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
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
        _tableView.estimatedRowHeight = 58;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!self.evaluateList) {
        return 0;
    }
    
    ZXAmountEvaluateListModel *listModel = self.evaluateList[section];
    if (!listModel ||
        !IsValidArray(listModel.taskItems)) {
        return 0;
    }

    if (!listModel.isUnfold) {
        return 1;
    }
    
    if (section == SectionType300) {

        ZXAmountEvaluateListModel *listModel = self.evaluateList[section];
        if (IsValidArray(listModel.taskItems) &&
            listModel.taskItems.count < 2) {
            return 2;
        }
        return 3;
    }
    else if(section == SectionType500){
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.separatorColor = UIColor.redColor;
    
    ZXAmountEvaluateListModel *listModel = self.evaluateList[indexPath.section];

    if (indexPath.row == 0) {//title
        ZXAmountInfoCell *cell = [ZXAmountInfoCell instanceCell:tableView];
        cell.contentView.backgroundColor = UIColor.clearColor;
        [cell updateWithData:listModel];
        return cell;
    }

    if (indexPath.section == SectionType300) {//300额度
        
        if (indexPath.row == 1) {
            if (listModel.taskItems.count < 2) {
                ZXAmountEvaluateRefCell *cell = [ZXAmountEvaluateRefCell instanceCell:tableView];
                cell.contentView.backgroundColor = UIColor.clearColor;

                [cell updateWithData:[self scoreItemsWithModel:listModel]];
                return cell;
            }
            ZXTaskCenterItemCell *cell = [ZXTaskCenterItemCell instanceCell:tableView];
            cell.contentView.backgroundColor = UIColor.clearColor;
            [cell updateWithData:[self incomeDetailItem]];
            cell.isBottom = NO;
            return cell;
        }
        else if (indexPath.row == 2) {//信用分
            ZXAmountEvaluateRefCell *cell = [ZXAmountEvaluateRefCell instanceCell:tableView];
            cell.contentView.backgroundColor = UIColor.clearColor;
            [cell updateWithData:[self scoreItemsWithModel:listModel]];
            return cell;
        }
    }
    
    
    ZXTaskCenterItemCell *cell = [ZXTaskCenterItemCell instanceCell:tableView];
    cell.contentView.backgroundColor = UIColor.clearColor;
    ZXTaskCenterItem *item = listModel.taskItems[indexPath.row-1];
    [cell updateWithData:item];
    cell.isBottom = indexPath.row == (listModel.taskItems.count);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [tableView defaultHeaderFooterView];
    headerView.backgroundColor = kThemeColorBg;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXAmountEvaluateListModel *listModel =  self.evaluateList[indexPath.section];

    if (indexPath.row == 0) {
        listModel.isUnfold = !listModel.isUnfold;
        [self.tableView reloadData];
        return;
    }
    
    ZXTaskCenterItem *item = listModel.taskItems[indexPath.row-1];
    
    if([item.certKey isEqualToString:@"salaryInfo"]){
        if ([item.certStatus isEqualToString:@"NotDone"] ||
            [item.certStatus isEqualToString:@"Expired"]) {
            
            [URLRouter routerUrlWithPath:kRouter_salaryInfo extra:@{@"certType":item.certKey,@"enablePopGesture":@(YES)}];
            
        }
        else{
            NSMutableDictionary *tmps = @{}.mutableCopy;
            [tmps setSafeValue:item.certKey forKey:@"certType"];
            [tmps setSafeValue:item.certStatus forKey:@"certStatus"];
            [tmps setSafeValue:item.certContent forKey:@"failureDesc"];
            [tmps setSafeValue:@(YES) forKey:@"canGoBack"];
            [URLRouter routerUrlWithPath:kRouter_uploadDetailResult extra:tmps.copy];
        }

    }
    else if([item.certKey isEqualToString:@"consumeInfo"]){
        if ([item.certStatus isEqualToString:@"NotDone"] ||
            [item.certStatus isEqualToString:@"Expired"]) {
            
            [URLRouter routerUrlWithPath:kRouter_consumeInfo extra:@{@"certType":item.certKey,@"enablePopGesture":@(YES)}];
        }
        else{
            
            NSMutableDictionary *tmps = @{}.mutableCopy;
            [tmps setSafeValue:item.certKey forKey:@"certType"];
            [tmps setSafeValue:item.certStatus forKey:@"certStatus"];
            [tmps setSafeValue:item.certContent forKey:@"failureDesc"];
            [tmps setSafeValue:@(YES) forKey:@"canGoBack"];

            [URLRouter routerUrlWithPath:kRouter_uploadDetailResult extra:tmps.copy];
        }
    }
    else if([item.certKey isEqualToString:@"bankIncomeDetails"]){
        /*if ([item.certStatus isEqualToString:@"Submit"] ||
            [item.certStatus isEqualToString:@"Resolved"]) {
            ZXResultNoteViewController *noteVC = [[ZXResultNoteViewController alloc] init];
            noteVC.payMessage = @"工资明细正在认证中 …";
            noteVC.resultPageType = ResultPageTypeWageAuthing;
            [self.navigationController pushViewController:noteVC animated:YES];
            return;
        }*/
        
       if([item.certStatus isEqualToString:@"NotDone"] ||
                [item.certStatus isEqualToString:@"Expired"]||
                [item.certStatus isEqualToString:@"Fail"]){
            [URLRouter routerUrlWithPath:kRouter_bankIncomeUpload extra:nil];
        }
       else{
           NSLog(@"----------");

       }
    }
    else{
        [URLRouter routerUrlWithPath:item.certKey extra:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 圆角角度
    CGFloat radius = 10.f;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 20, 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    
    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        normalBgView.clipsToBounds = NO;
    }else {
        normalBgView.clipsToBounds = YES;
        if (indexPath.row == 0) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
        }else if (indexPath.row == rowNum - 1) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
        }else {
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
    
    // 阴影
    normalLayer.shadowColor = [UIColor blackColor].CGColor;
    normalLayer.shadowOpacity = 0.2;
    normalLayer.shadowOffset = CGSizeMake(2, 2);
    normalLayer.path = bezierPath.CGPath;
    normalLayer.shadowPath = bezierPath.CGPath;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
    
    // 替换cell点击效果
    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
    selectLayer.fillColor = [UIColor colorWithWhite:0.95 alpha:1.0].CGColor;
    [selectBgView.layer insertSublayer:selectLayer atIndex:0];
    selectBgView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectBgView;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        CGFloat cornerRadius = 10.f;
//        cell.backgroundColor = UIColor.clearColor;
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
//        BOOL addLine = NO;
//        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//        } else if (indexPath.row == 0) {
//
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//            addLine = YES;
//
//        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//        } else {
//            CGPathAddRect(pathRef, nil, bounds);
//            addLine = YES;
//        }
//        layer.path = pathRef;
//        CFRelease(pathRef);
//        //颜色修改
//        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
//        layer.strokeColor=[UIColor blackColor].CGColor;
//        if (addLine == YES) {
//            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
//            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//            [layer addSublayer:lineLayer];
//        }
//        UIView *testView = [[UIView alloc] initWithFrame:bounds];
//        [testView.layer insertSublayer:layer atIndex:0];
//        testView.backgroundColor = UIColor.clearColor;
//        cell.backgroundView = testView;
//    }
//}
@end
