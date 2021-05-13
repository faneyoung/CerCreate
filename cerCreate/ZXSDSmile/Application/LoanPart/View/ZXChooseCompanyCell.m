//
//  ZXChooseCompanyCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/11.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXChooseCompanyCell.h"
#import "UIView+help.h"
#import <SDWebImage.h>

#import "UIButton+Align.h"

@implementation ZXCompanySelectionModel

@end

#define kChooseItemBaseTag   100000

@interface ZXChooseCompanyCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) ZXCompanySelectionModel *selectionModel;

@end


@implementation ZXChooseCompanyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupViews];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - views -

- (void)setupViews{
    
    UIView *selectView = [[UIView alloc] init];
    [self.contentView addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(54);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.font = FONT_PINGFANG_X(16);
    lab.textColor = TextColorTitle;
    [selectView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(16);
        make.left.inset(20);
        make.height.mas_equalTo(22);
    }];
    self.titleLab = lab;
    
    UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"choose_employer_uncheck"] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"choose_employer_checked"] forState:(UIControlStateSelected)];
    [selectView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(0);
        make.right.inset(10);
        make.width.mas_equalTo(54);
    }];
    
    @weakify(self);
    [btn bk_addEventHandler:^(UIButton *sender) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(checkBtn:item:)]) {
            [self.delegate checkBtn:sender item:self.selectionModel];
        }
        
        if (IsValidArray(self.selectionModel.companys)) {
            [self resetCompanyViews:self.selectionModel.companys];
        }
    
        
    } forControlEvents:UIControlEventTouchUpInside];
    self.checkBtn = btn;
    
    
    UIView *containerView = [[UIView alloc] init];
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selectView.mas_bottom);
        make.left.right.bottom.inset(0);
        make.height.mas_equalTo(0);
    }];
    self.containerView = containerView;
    
}

#pragma mark - data -

- (void)updateWithData:(ZXCompanySelectionModel*)model{
    self.titleLab.text = model.title;
    self.checkBtn.selected = model.selected;
    self.selectionModel = model;
    
    [self resetCompanyViews:model.companys];
}

- (void)resetCompanyViews:(NSArray*)companys{
    
    if (!IsValidArray(companys) ||
        !self.selectionModel.selected) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.containerView layoutIfNeeded];
        [self.contentView layoutIfNeeded];
        return;
    }
    
    
    [self.containerView removeAllSubviews];
    
    CGFloat h = 123;
    CGFloat space = 0;
    CGFloat contentW = SCREEN_WIDTH()/2;
    UIFont *font = FONT_PINGFANG_X(14);
    
    __block CGFloat startX = 0;
    __block CGFloat startY = 0;
    [companys enumerateObjectsUsingBlock:^(ZXSDCompanyModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if (startX > contentW) {
            startX = 0;
            startY += (h + space);
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = font;
        btn.titleEdgeInsets = UIEdgeInsetsMake(65, 0, 0, 0);
        [btn setTitleColor:TextColorTitle forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColorMain forState:UIControlStateSelected];
        [btn setTitle:GetStrDefault(obj.shortName, @"--") forState:UIControlStateNormal];
        btn.tag = kChooseItemBaseTag + idx;
        [btn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(startY);
            make.left.inset(startX);
            make.width.mas_equalTo(contentW);
            make.height.mas_equalTo(h);
        }];
        btn.selected = obj.selecteStatus;
        
        
        UIView *logoBgView = [[UIImageView alloc] init];
        logoBgView.backgroundColor = UIColorFromHex(0xF7F9FB);
        logoBgView.userInteractionEnabled = NO;
        [btn addSubview:logoBgView];
        [logoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(10);
            make.width.height.mas_equalTo(68);
            make.centerX.offset(0);
        }];
        UIColor *borderColor = obj.selecteStatus ? kThemeColorMain : UIColor.whiteColor;
        ViewBorderRadius(logoBgView, 34, 1, borderColor);

        UIImageView *logoView = [[UIImageView alloc] init];
        logoView.contentMode = UIViewContentModeScaleAspectFill;
        [logoView sd_setImageWithURL:GetString(obj.logoUrl).URLByCheckCharacter placeholderImage:UIImageNamed(@"")];
        [logoBgView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.width.height.mas_equalTo(44);
        }];
        ViewBorderRadius(logoView, 22, 0.01, UIColor.clearColor);

        
        startX += contentW;
        
        if (startX == contentW) {
            UILabel *sepLine = [[UILabel alloc] init];
            sepLine.backgroundColor = kThemeColorLine;
            [self.containerView addSubview:sepLine];
            [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.inset(startY-1);
                make.left.right.inset(20);
                make.height.mas_equalTo(1);
            }];
        }
    }];
    
    if (companys.count) {
        startY += h;
    }
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(startY);
    }];
    [self.containerView layoutIfNeeded];
    [self.contentView layoutIfNeeded];
}

#pragma mark - action -
- (void)itemBtnClicked:(UIButton*)btn{
    if (!IsValidArray(self.selectionModel.companys)) {
        return;
    }
    
    int idx = (int)btn.tag-kChooseItemBaseTag;
    if ([self.delegate respondsToSelector:@selector(itemSelectedAtIndex:item:)]) {
        [self.delegate itemSelectedAtIndex:idx item:self.selectionModel];
    }
    

}


@end
