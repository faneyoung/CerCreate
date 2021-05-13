//
//  ZXMemberCreateOptionCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/2/24.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXMemberCreateOptionCell.h"
#import "UIButton+Align.h"
#import "UITableView+help.h"

#import "CJLabel.h"
#import "ZXMemberOptionAdvanceCell.h"
#import "ZXMemberOptionMoreLevelCell.h"
#import "ZXMemberOptionExtensionCell.h"
#import "ZXMemberOptionServiceCell.h"
#import "ZXMemberInfoModel.h"


@interface ZXMemberCreateOptionCell () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreLevelBtn;
@property (weak, nonatomic) IBOutlet UIButton *extensionBtn;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCSHeight;
@property (nonatomic, strong) UIImageView *extensionLine;


@property (nonatomic, strong) NSArray *optionBtns;
@property (nonatomic, strong) UIButton *selectedBtn;


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CJLabel *recommandLab;

@property (nonatomic, strong) NSArray *preItems;
@property (nonatomic, strong) NSArray *levelItems;
@property (nonatomic, strong) NSArray *extensionItems;
@property (nonatomic, strong) NSArray *serviceItems;

@property (nonatomic, strong) id infoModel;

@end

@implementation ZXMemberCreateOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.preBtn alignWithType:ButtonAlignImgTypeTop margin:1];
    [self.moreLevelBtn alignWithType:ButtonAlignImgTypeTop margin:1];
    [self.extensionBtn alignWithType:ButtonAlignImgTypeTop margin:1];
    [self.serviceBtn alignWithType:ButtonAlignImgTypeTop margin:1];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubviews{
    
    [self.preBtn setImage:UIImageNamed(@"icon_member_item_pre") forState:UIControlStateNormal];
    [self.preBtn setImage:UIImageNamed(@"icon_member_item_preH") forState:UIControlStateSelected];
    [self.preBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    [self.preBtn setTitleColor:TextColorTitle forState:UIControlStateSelected];
    
    [self.moreLevelBtn setImage:UIImageNamed(@"icon_member_item_level") forState:UIControlStateNormal];
    [self.moreLevelBtn setImage:UIImageNamed(@"icon_member_item_levelH") forState:UIControlStateSelected];
    [self.moreLevelBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    [self.moreLevelBtn setTitleColor:TextColorTitle forState:UIControlStateSelected];

    [self.extensionBtn setImage:UIImageNamed(@"icon_member_item_extension") forState:UIControlStateNormal];
    [self.extensionBtn setImage:UIImageNamed(@"icon_member_item_extensionH") forState:UIControlStateSelected];
    [self.extensionBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    [self.extensionBtn setTitleColor:TextColorTitle forState:UIControlStateSelected];

    [self.serviceBtn setImage:UIImageNamed(@"icon_member_item_server") forState:UIControlStateNormal];
    [self.serviceBtn setImage:UIImageNamed(@"icon_member_item_serverH") forState:UIControlStateSelected];
    [self.serviceBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    [self.serviceBtn setTitleColor:TextColorTitle forState:UIControlStateSelected];
    
    self.optionBtns = @[self.preBtn,self.moreLevelBtn,self.extensionBtn,self.serviceBtn];
    self.preBtn.selected = YES;
    self.selectedBtn = self.preBtn;
    
    [self.containerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXMemberOptionAdvanceCell.class),
        NSStringFromClass(ZXMemberOptionMoreLevelCell.class),
        NSStringFromClass(ZXMemberOptionExtensionCell.class),
        NSStringFromClass(ZXMemberOptionServiceCell.class),
    ]];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = UIImageNamed(@"icon_member_extension_line");
    [self.containerView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(0);
        make.centerX.offset(0);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(164);
    }];
    self.extensionLine = imgView;
    self.extensionLine.hidden = YES;
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

#pragma mark - action methods -

- (IBAction)optionBtnClicked:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    
    sender.selected = !sender.selected;
    self.selectedBtn = sender;
    self.extensionLine.hidden = YES;
    
    [self.optionBtns enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj.currentTitle isEqualToString:sender.currentTitle]) {
            obj.selected = !sender.selected;
        }
    }];
    
    CGFloat footHeight = 57;
    CGFloat rowHeight = 50;
    CGFloat rowCount = 0;
    if (sender.tag == 0) {
        self.titleLab.text = @"提前预支工资";
        rowCount = self.preItems.count;
    }
    else if(sender.tag == 1){
        self.titleLab.text = @"更多预支档位";
        rowCount = self.levelItems.count;
        footHeight = 8.0;
    }
    else if(sender.tag == 2){
        self.titleLab.text = @"预支展期";
        self.extensionLine.hidden = NO;

        rowHeight = 60;
        rowCount = self.extensionItems.count;
        
    }
    else if(sender.tag == 3){
        self.titleLab.text = @"专属客服";
        rowHeight = 75;
        footHeight = 10;
        rowCount = self.serviceItems.count;
    }
    
    [self.tableView reloadData];
    
    CGFloat containerHeight = rowCount * rowHeight + footHeight;
    self.containerCSHeight.constant = containerHeight;

    [self.containerView layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    
    if (self.optionSelectedBlock) {
        self.optionSelectedBlock((int)sender.tag);
    }
}

#pragma mark - data -

- (void)updateWithData:(ZXMemberInfoModel*)model{
    self.infoModel = model;
    [self.tableView reloadData];
}

- (NSArray *)preItems{
    
    NSString *totalResult = nil;
    if (IsValidString(self.loanAmount)) {
        CGFloat total = [self.loanAmount integerValue] + [self.interest floatValue];
        totalResult = [NSString stringWithFormat:@"%.2f", total];
    }

    return @[
        @{@"title":@"预支金额",@"des":GetStrDefault(self.loanAmount, @"￥300/￥500/￥1000")},
        @{@"title":@"利息",@"des":GetStrDefault(self.interest, @"0")},
        @{@"title":@"扣款日",@"des":@"下一个发薪日"},
        @{@"title":@"应还本息",@"des":GetStrDefault(totalResult, @"￥300/￥500/￥1000")},
    ];
}

- (NSArray *)levelItems{
    return @[
        @{@"title":@"用户类型",@"status":@"未开通",@"des":@"已开通"},
        @{@"title":@"个人用户",@"status":@"--",@"des":@"￥300 ￥500 ￥1000"},
        @{@"title":@"合作企业用户",@"status":@"￥500",@"des":@"￥1000 ￥1500 ￥2000"},
    ];
}

- (NSArray *)extensionItems{
    return @[
        @{@"title":@"预支日期",@"des":@"2020.07.01"},
        @{@"title":@"应还金额",@"des":@"￥500"},
        @{@"title":@"还款日",@"status":@"2020.08.10",@"des":@"2020.07.10"},
    ];
}

- (NSArray *)serviceItems{
    return @[
        @{@"title":@"电话客服",@"des":@"贵宾专线，贴心解答疑问",@"image":@"icon_member_option_phone"},
        @{@"title":@"微信公众号客服",@"des":@"专属客服经理，优先提供服务",@"image":@"icon_member_option_wx"},
        @{@"title":@"企业微信客服",@"des":@"专属客服经理，优先提供服务",@"image":@"icon_member_option_qwx"},
    ];
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSArray*)dataSource{
    if (self.selectedBtn.tag == 0) {
        
        return self.preItems;
    }
    else if(self.selectedBtn.tag == 1){
        return self.levelItems;
    }
    else if(self.selectedBtn.tag == 2){
        return self.extensionItems;
    }
    else if(self.selectedBtn.tag == 3){
        return self.serviceItems;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self dataSource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedBtn.tag == 0) {
        ZXMemberOptionAdvanceCell *cell = [ZXMemberOptionAdvanceCell instanceCell:tableView];
        
        [cell updateViewsWithData:self.preItems[indexPath.row]];
        return cell;
    }
    else if(self.selectedBtn.tag == 1){
        ZXMemberOptionMoreLevelCell *cell = [ZXMemberOptionMoreLevelCell instanceCell:tableView];
        cell.isFirstRow = indexPath.row == 0;
        [cell updateViewsWithData:self.levelItems[indexPath.row]];
        return cell;
    }
    else if(self.selectedBtn.tag == 2){
        ZXMemberOptionExtensionCell *cell = [ZXMemberOptionExtensionCell instanceCell:tableView];
        cell.isLastRow = indexPath.row == self.extensionItems.count-1;
        [cell updateViewsWithData:self.extensionItems[indexPath.row]];
        return cell;
    }
    else if(self.selectedBtn.tag == 3){
        ZXMemberOptionServiceCell *cell = [ZXMemberOptionServiceCell instanceCell:tableView];
        [cell updateViewsWithData:self.serviceItems[indexPath.row]];
        return cell;
    }

    
    return [tableView defaultReuseCell];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedBtn.tag == 0) {
        return 50;
    }
    else if(self.selectedBtn.tag == 1){
        return 50;
    }
    else if(self.selectedBtn.tag == 2){
        return 60;
    }
    else if(self.selectedBtn.tag == 3){
        return 75;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.selectedBtn.tag == 1 ||
        self.selectedBtn.tag == 3) {
        return 10;
    }
    
    return 56;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (NSArray*)footTitles{
    return @[
        @"当月只能预支一次",
        @" ",
        @"需支付展期费用 ：￥10 / 次",
    ];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.clipsToBounds = YES;
    footerView.backgroundColor = UIColor.whiteColor;
    
    UILabel *sepLab = [[UILabel alloc] init];
    sepLab.backgroundColor = kThemeColorLine;
    [footerView addSubview:sepLab];
    [sepLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(8);
    }];

    
    if (self.selectedBtn.tag != 3) {

        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = FONT_PINGFANG_X(11);
        titleLab.textColor = TextColorgray;
        titleLab.text = [self footTitles][self.selectedBtn.tag];
        [footerView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(16);
            make.left.inset(20);
            make.height.mas_equalTo(16);
        }];
        
//        if (self.selectedBtn.tag == 1) {
//            [footerView addSubview:self.recommandLab];
//            [self.recommandLab mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(titleLab.mas_right).inset(5);
//                make.height.mas_equalTo(20);
//                make.centerY.mas_equalTo(titleLab);
//            }];
//        }
        

    }
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (CJLabel *)recommandLab
{
    if (!_recommandLab) {
        NSString *protocolString = @"邀请我司";
        UIFont *currentFont = FONT_PINGFANG_X(11);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:protocolString];
        
        _recommandLab = [[CJLabel alloc] initWithFrame:CGRectZero];
        _recommandLab.numberOfLines = 0;
        _recommandLab.textAlignment = NSTextAlignmentCenter;
        
        attributedString = [CJLabel configureAttributedString:attributedString
                                                      atRange:NSMakeRange(0, attributedString.length)
                                                   attributes:@{
                                                       NSForegroundColorAttributeName:TextColorgray,
                                                       NSFontAttributeName:currentFont,
                                                      
                                                   }];
        attributedString = [CJLabel configureLinkAttributedString:attributedString
                                                       withString:@"邀请我司"
                                                 sameStringEnable:NO
                                                   linkAttributes:@{
                                                       NSForegroundColorAttributeName:UICOLOR_FROM_HEX(0x3C74CE),
                                                       NSFontAttributeName:currentFont,
                                                   }
                                             activeLinkAttributes:nil
                                                        parameter:nil
                                                   clickLinkBlock:^(CJLabelLinkModel *linkModel){
            [URLRouter routerUrlWithPath:kRouter_inviteCompany extra:nil];
        }longPressBlock:^(CJLabelLinkModel *linkModel){
            [URLRouter routerUrlWithPath:kRouter_inviteCompany extra:nil];
        }];
        _recommandLab.attributedText = attributedString;
        _recommandLab.extendsLinkTouchArea = YES;
    }
    return _recommandLab;
}




@end
