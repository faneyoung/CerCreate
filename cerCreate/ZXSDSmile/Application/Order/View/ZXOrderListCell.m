//
//  ZXOrderListCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/15.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXOrderListCell.h"
#import "UIButton+ExpandClickArea.h"

#import "ZXOrderListModel.h"

@interface ZXOrderListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UIView *topInfoView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIView *goodsContainerView;

@property (weak, nonatomic) IBOutlet UIView *actionContainerView;

@property (nonatomic, strong) ZXOrderListModel *orderModel;

@end

@implementation ZXOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgImgView.image = [UIIMAGE_FROM_NAME(@"icon_order_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 70, 30) resizingMode:(UIImageResizingModeStretch)];

    self.orderTitleLab.font = FONT_Akrobat_regular(12);
//    self.priceLab.font = FONT_Akrobat_bold(13.0);
    self.timeLab.font = FONT_Akrobat_Semibold(11.0);
    self.timeLab.textColor = UIColorFromHex(0xB3B3B3);
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - data -
- (void)updateWithData:(ZXOrderListModel*)model{
    self.orderModel = model;
    
    
    NSString *orderNo = [model.channel isEqualToString:@"fulu"] ? GetString(model.refId) : GetString(model.orderNo);
    self.orderTitleLab.text = orderNo;

    self.statusLab.text = model.statusStr;
    
    [self.goodsContainerView removeAllSubviews];
    CGFloat width = 63;
    CGFloat height = 63;
    CGFloat vSpace = 9;
    [model.goodsList enumerateObjectsUsingBlock:^(ZXGoodsModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = kThemeColorBg;
        ViewBorderRadius(imgView, 4, 0.01, UIColor.whiteColor);
        [self.goodsContainerView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset((height+vSpace)*idx);
            make.left.inset(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            
            if (idx == model.goodsList.count-1) {
                make.bottom.inset(0);
            }
        }];
        
        __weak typeof(imgView)weakImgView = imgView;
        imgView.backgroundColor = kThemeColorBg;
        [imgView setImgWithUrl:obj.showMages completed:^(UIImage * _Nonnull image) {
            if (image) {
                weakImgView.backgroundColor = UIColor.whiteColor;
            }
        }];
        
        UILabel *lab = [UILabel labelWithText:obj.commodityName textColor:UICOLOR_FROM_HEX(0x313131) font:FONT_PINGFANG_X(12)];
        [self.goodsContainerView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(imgView);
                    make.left.mas_equalTo(imgView.mas_right).inset(15);
                    make.right.inset(22);
        }];
        
        UILabel *priceLab = [UILabel labelWithText:[NSString stringWithFormat:@"￥%@",GetStrDefault(obj.showAmount, @"0")] textColor:kThemeColorMain font:FONT_Akrobat_bold(13)];
        [self.goodsContainerView addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab);
            make.bottom.mas_equalTo(imgView);
            make.height.mas_equalTo(18);
        }];
        
        UILabel *numLab = [UILabel labelWithText:[NSString stringWithFormat:@"x%@",GetStrDefault(obj.commodityNumber, @"0")] textColor:UIColorFromHex(0x979797) font:FONT_Akrobat_bold(13)];
        [self.goodsContainerView addSubview:numLab];
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(22);
            make.centerY.mas_equalTo(priceLab);
            make.height.mas_equalTo(18);
        }];
    }];
    
    
    
    
    
    
    self.timeLab.text = model.formatterTime;
    
    [self.actionContainerView removeAllSubviews];
    
    CGFloat btnWidth = 78;
    CGFloat btnHeight = 24;
    

    if ([model.status isEqualToString:@"0"] &&
        [model.channel isEqualToString:@"fulu"]) {
        
        UIButton *btn = [self toPayBtn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(0);
            make.bottom.inset(9);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
        }];
        
        UIButton *detailBtn = [self detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(btn.mas_left).inset(12);
            make.centerY.mas_equalTo(btn);
            make.width.height.mas_equalTo(btn);
        }];


    }
    else{
        UIButton *detailBtn = [self detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.inset(0);
            make.bottom.inset(9);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
        }];
    }
    
}

- (UIButton*)toPayBtn{
    UIButton *btn = [UIButton buttonWithFont:FONT_PINGFANG_X(11) title:self.orderModel.statusStr textColor:UIColor.whiteColor];
    btn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, 0, -10, 0);
    [btn setTitle:@"待支付" forState:UIControlStateNormal];
    [btn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
    [self.actionContainerView addSubview:btn];
    ViewBorderRadius(btn, 12, 0.01, UIColor.whiteColor);
    [btn bk_addEventHandler:^(id sender) {
        if (self.orderBtnBlock) {
            self.orderBtnBlock(OrderBtnTypeToPay);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton*)detailBtn{
    UIButton *detailBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(11) title:self.orderModel.statusStr textColor:UIColorFromHex(0x979797)];
    detailBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-10, 0, -10, 0);
    [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    detailBtn.backgroundColor = UIColor.whiteColor;
    [self.actionContainerView addSubview:detailBtn];
    ViewBorderRadius(detailBtn, 12, 0.5, UIColorFromHex(0x979797));
    
    [detailBtn bk_addEventHandler:^(id sender) {
        if (self.orderBtnBlock) {
            self.orderBtnBlock(OrderBtnTypeDetail);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    return detailBtn;
}



@end
