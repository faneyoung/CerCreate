//
//  ZXCardListViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/6.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCardListViewController.h"
#import "UITableView+help.h"

//views
#import "ZXCardListCell.h"

#import "EPNetworkManager+Mine.h"

@interface ZXCardListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;


@property (nonatomic, strong) NSArray *cardList;

///当前列表页所选card
@property (nonatomic, strong) ZXSDBankCardItem *selectedCard;

@end

@implementation ZXCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"工资卡管理";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestAllCardList];
}

#pragma mark - views -
- (void)setupSubViews{
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = FONT_PINGFANG_X(14);
    [confirmBtn setBackgroundColor:TextColorDisable];
    ViewBorderRadius(confirmBtn, 22, 0.1, UIColor.whiteColor);
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
        make.bottom.inset(kBottomSafeAreaHeight+16);
    }];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.confirmBtn = confirmBtn;
    [self updataConfirmBtnEnable:NO];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.bottom.mas_equalTo(confirmBtn.mas_top);
    }];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXCardListCell.class),
    ]];
    
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
        
        
    }
    return _tableView;
}


- (void)updataConfirmBtnEnable:(BOOL)enable{
    
    self.confirmBtn.userInteractionEnabled  = enable;

    if (!enable) {
        [self.confirmBtn setTitleColor:TextColorPlacehold forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundColor:TextColorDisable];
        [self.confirmBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

        [self.confirmBtn setBackgroundImage:[UIImage  imageWithGradient:@[UIColorFromHex(0x00C35A),UIColorFromHex(0x00D663),] size:CGSizeMake(104, 44) direction:UIImageGradientDirectionRightSlanted] forState:UIControlStateNormal];
    }
}


#pragma mark - data handle -

- (ZXSDBankCardItem *)selectedCard{
    __block ZXSDBankCardItem *selCard = nil;
    [self.cardList enumerateObjectsUsingBlock:^(ZXSDBankCardItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            selCard = obj;
            *stop = YES;
        }
    }];
    
    return selCard;
}

- (void)requestAllCardList{
    [self showLoadingProgressHUDWithText:kLoadingTip];
    @weakify(self);
    [EPNetworkManager getUserBankCards:nil completion:^(NSArray<ZXSDBankCardItem *> *records, NSError *error) {
        @strongify(self);
        
        [self dismissLoadingProgressHUDImmediately];
        
        if (error) {
//            [self handleRequestError:error];
            return;
        }

        if (!self.card) {
            ZXSDBankCardItem *card = records.firstObject;
            card.selected = YES;
        }
        else{
            
            [records enumerateObjectsUsingBlock:^(ZXSDBankCardItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.bankCode isEqualToString:self.card.bankCode]) {
                    obj.selected = self.card;
                    *stop = YES;
                }
            }];
        }

        self.cardList = records;
        [self.tableView reloadData];
        
        [self updataConfirmBtnEnable:self.selectedCard.selected];
    }];

}

#pragma mark - action methdos -
- (void)confirmBtnClick{
    [self backButtonClicked:nil];
    
    if (self.completionBlock) {
        self.completionBlock(self.selectedCard);
    }
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXCardListCell *cell = [ZXCardListCell instanceCell:tableView];
    
    [cell updateWithData:self.cardList[indexPath.row]];
    
    return cell;
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
    
    [self.cardList enumerateObjectsUsingBlock:^(ZXSDBankCardItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (indexPath.row == idx) {
            obj.selected = !obj.selected;
        }
        else{
            if (obj.selected) {
                obj.selected = NO;
            }
        }
        
    }];
    
    [tableView reloadData];
    
    [self updataConfirmBtnEnable:self.selectedCard.selected];
    
}


@end
