//
//  ZXCerCreateViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCerCreateViewController.h"
#import <IQKeyboardManager.h>
#import "UITableView+help.h"
#import "BRDatePickerView.h"

//vc
#import "ZXCerViewController.h"

#import "ZXCerInputCell.h"
#import "ZXCerLongTextCell.h"

#import "ZXCerModel.h"

@interface ZXCerCreateViewController ()


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *placeholders;
@property (nonatomic, strong) ZXCerModel *model;

@end

@implementation ZXCerCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    

    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        UITextField *tf = note.object;
        
        [self inputStrParsing:tf];
        
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        UITextView *tf = note.object;
        
        [self inputStrParsing:tf];

    }];
    
    
    
    
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXCerInputCell.class),
        NSStringFromClass(ZXCerLongTextCell.class),
    ]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

#pragma mark - data -
- (NSArray *)placeholders{
    if (!_placeholders) {
        _placeholders = @[
            @"请输入统一社会信用代码",
            @"请输入公司名",
            @"请输入类型",
            @"请输入法定代表人",
            @"请输入经营范围",
            @"请输入注册资本",
            @"请输入成立日期",
            @"请输入营业日期",
            @"请输入地址",
            @"请输入日期",
            @"请输入登记机关",
            @"请输入副本",
        ];
    }
    return _placeholders;
}

- (ZXCerModel *)model{
    if (!_model) {
        _model = [[ZXCerModel alloc] init];
#warning &&&& test -->>>>>
        _model.code = @"915100002018019987";
        _model.company = @"四川省第六建筑有限公司";
        _model.type = @"有限责任公司（非自然人投资或控股的法人独资）";
        _model.name = @"张义颜";
        _model.business = @"对外承包工程（以上经营项目及期限以许可证为准）。（以下范围不含前置许可项目，后置许可项目凭许可证或审批文件经营）建筑工程；市政公用工程；预应力工程；建筑装修装饰工程；施工劳作作业；消防设施工程；电梯安装工程；建筑机电安装工程；起重设备安装工程；特种工程；钢结构工程；建筑机械设备租赁及维修；地基基础工程；土石方工程服务；防水防腐保温工程；金属门窗工程；进出口业；商品批发与零售。（依法须经批准的项目，经相关部门批准就方可开展经营活动）";
        _model.amount = @"叁亿元整";
        _model.createTime = @"1980年04月24日";
        _model.yingyeTime = @"";
        _model.address = @"成都市金牛区星辉中路16号";
        _model.registUnit = @"四川省市场监督管理局";
        _model.time = @"2020.7.1";
#warning <<<<<<-- test &&&&

    }
    
    return _model;
}

- (void)inputStrParsing:(UITextField*)tf{
    
    [self.placeholders enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if ([obj isEqualToString:tf.placeholder]) {
            
            if (idx == 0) {
                self.model.code = tf.text;
            }
            else if(idx == 1){
                self.model.company = tf.text;
            }
            else if(idx == 2){
                self.model.type = tf.text;
            }
            else if(idx == 3){
                self.model.name = tf.text;
            }
            else if(idx == 4){
                self.model.business = tf.text;
            }
            else if(idx == 5){
                self.model.amount = tf.text;
            }
            else if(idx == 6){
                self.model.createTime = tf.text;
            }
            else if(idx == 7){
                self.model.yingyeTime = tf.text;
            }
            else if(idx == 8){
                self.model.address = tf.text;
            }
            else if(idx == 9){
                self.model.time = tf.text;
            }
            else if(idx == 10){
                
                self.model.registUnit = tf.text;
            }
            else if(idx == 11){
                self.model.fuben = tf.text;
                
            }
            
            *stop = YES;
        }
    }];
    
    
}

#pragma mark - views -
- (void)setupSubViews{
    UIButton *btn = [UIButton buttonWithFont:FONT_PINGFANG_X(15) title:@"生成" textColor:UIColor.whiteColor];
    [btn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(50);
        make.bottom.inset(kBottomSafeAreaHeight+20);
        make.height.mas_equalTo(50);
    }];
    ViewBorderRadius(btn, 25, 1, UIColor.whiteColor);
    [btn bk_addEventHandler:^(id sender) {
        [self btnClicked:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(btn.mas_top);
    }];
    
    
    
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 158;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        
    }
    return _tableView;
}

#pragma mark - action -

- (IBAction)btnClicked:(id)sender {
        
    ZXCerViewController *cerVC = [[ZXCerViewController alloc] init];
    cerVC.cerModel = self.model;
    [self.navigationController pushViewController:cerVC animated:YES];
    
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.placeholders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 4 ||
        indexPath.row == 8) {
        
        ZXCerLongTextCell *cell = [ZXCerLongTextCell instanceCell:tableView];
        cell.textField.placeholder = self.placeholders[indexPath.row];
        cell.textField.text = [self inputTextWithIndexPath:indexPath];

        return cell;
    }

    ZXCerInputCell *cell = [ZXCerInputCell instanceCell:tableView];

    cell.textField.placeholder = self.placeholders[indexPath.row];
    cell.textField.text = [self inputTextWithIndexPath:indexPath];
    
    cell.textField.userInteractionEnabled = YES;
    if (indexPath.row == 6 ||
        indexPath.row == 7 ||
        indexPath.row == 9) {
        cell.textField.userInteractionEnabled = NO;
    }


    return cell;
}

- (NSString*)inputTextWithIndexPath:(NSIndexPath*)indexPath{
    NSString *str = @"";
    if (indexPath.row == 0) {
        str = self.model.code;
    }
    else if(indexPath.row == 1){
        str = self.model.company;
    }
    else if(indexPath.row == 2){
        str = self.model.type;
    }
    else if(indexPath.row == 3){
        str = self.model.name;
    }
    else if(indexPath.row == 4){
        str = self.model.business;
    }
    else if(indexPath.row == 5){
        str = self.model.amount;
    }
    else if(indexPath.row == 6){
        str = self.model.createTime;
    }
    else if(indexPath.row == 7){
        str = self.model.yingyeTime;
    }
    else if(indexPath.row == 8){
        str = self.model.address;
    }
    else if(indexPath.row == 9){
        str = self.model.time;
    }
    else if(indexPath.row == 10){
        str = self.model.registUnit;
    }
    else if(indexPath.row == 11){
        str = self.model.fuben;
    }
    
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 100.0;
    }
    else if(indexPath.row == 8){
        return 100.0;
    }
    return UITableViewAutomaticDimension;
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
    
    if (indexPath.row == 6 ||
        indexPath.row == 7 ||
        indexPath.row == 9) {
        [self showDatePickerWithIndex:indexPath];
    }
    
}

- (void)showDatePickerWithIndex:(NSIndexPath*)indexPath{
    
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc] init];
    datePickerView.pickerStyle.maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    datePickerView.pickerStyle.titleBarHeight = 50.0;
    datePickerView.pickerStyle.topCornerRadius = 16.0;
    datePickerView.pickerStyle.cancelTextColor = UICOLOR_FROM_HEX(0x333333);
    datePickerView.pickerStyle.titleTextColor = UICOLOR_FROM_HEX(0x181C1F);
    datePickerView.pickerStyle.titleTextFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    datePickerView.pickerStyle.doneTextColor = UICOLOR_FROM_HEX(0x00B050);
    datePickerView.pickerStyle.hiddenTitleLine = YES;
    datePickerView.pickerMode = BRDatePickerModeYMD;
    datePickerView.title = @"选择时间";
    datePickerView.minDate = [NSDate br_setYear:1900 month:1 day:1];
    datePickerView.maxDate = [NSDate date];
    datePickerView.isAutoSelect = NO;
    datePickerView.showToday = YES;
    datePickerView.showUnitType = BRShowUnitTypeNone;
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        selectValue = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@"."];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy年MM月dd日";
        NSString *dateStr = [formatter stringFromDate:selectDate];

        if (indexPath.row == 6) {
            self.model.createTime = dateStr;
        }
        else if(indexPath.row == 7){
            self.model.yingyeTime = dateStr;
        }
        else if(indexPath.row == 9){
            self.model.time = selectValue;
        }
        
        [self.tableView reloadData];
    };
    
    [datePickerView show];
}
@end
