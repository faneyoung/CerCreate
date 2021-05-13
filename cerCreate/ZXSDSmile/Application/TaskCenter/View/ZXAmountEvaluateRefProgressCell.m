//
//  ZXAmountEvaluateRefProgressCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/9.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXAmountEvaluateRefProgressCell.h"
#import "MBCircularProgressBarView.h"

#import "ZXTaskCenterModel.h"

@interface ZXAmountEvaluateRefProgressCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) MBCircularProgressBarView *progressBar;
@property (nonatomic, strong) UILabel *doneValueLabel;
@property (nonatomic, strong) UILabel *doneValueDesLabel;
@property (nonatomic, assign) BOOL animating;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;


@property (nonatomic, strong) UIButton *statusImgView;

@property (nonatomic, strong) ZXTaskCenterItem *taskItem;



@end

@implementation ZXAmountEvaluateRefProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}

- (void)setupSubViews{
    
    [self.containerView addSubview:self.progressBar];
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(110);
        make.centerX.offset(0);
        make.centerY.offset(5);
    }];
    
    [self.progressBar addSubview:self.doneValueLabel];
    [self.doneValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressBar).inset(25);
        make.centerX.equalTo(self.progressBar);
    }];
    
    UILabel *descLabel = [UILabel labelWithText:@"芝麻信用分" textColor:UICOLOR_FROM_HEX(0x3C74CE) font:FONT_PINGFANG_X(11)];
    [self.progressBar addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressBar);
        make.top.equalTo(self.doneValueLabel.mas_bottom).inset(-2);
    }];
    self.doneValueDesLabel = descLabel;
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.titleLabel.font = FONT_PINGFANG_X(11.0);
    updateBtn.userInteractionEnabled = NO;
    updateBtn.backgroundColor = kThemeColorBlue;
    [updateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.progressBar addSubview:updateBtn];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-10);
        make.left.mas_equalTo(self.doneValueDesLabel).inset(-3);
        make.right.mas_equalTo(self.doneValueDesLabel).inset(-3);
        make.height.mas_equalTo(22);
    }];
    ViewBorderRadius(updateBtn, 11, 0.01, UIColor.clearColor);
    self.uploadBtn = updateBtn;
    
    UIButton *statusImgView = [UIButton buttonWithType:UIButtonTypeCustom];
    [statusImgView setImage:UIImageNamed(@"icon_task_unauthentic") forState:UIControlStateNormal];
    statusImgView.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.progressBar addSubview:statusImgView];
    [statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.inset(0);
        make.width.height.mas_equalTo(24);
    }];
    [statusImgView addTarget:self action:@selector(statusIconClicked) forControlEvents:UIControlEventTouchUpInside];
    statusImgView.hidden = YES;
    self.statusImgView = statusImgView;

}

- (MBCircularProgressBarView *)progressBar{
    if (!_progressBar) {
        _progressBar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH() - 148)/2.0, 20, 148, 100)];
        _progressBar.progressLineWidth = 10;
        _progressBar.emptyLineWidth = 10;
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.progressCapType = kCGLineCapSquare;
        _progressBar.emptyCapType = kCGLineCapSquare;
        _progressBar.showValueString = NO;
        _progressBar.progressAngle = 70;
        
        _progressBar.emptyLineColor = UICOLOR_FROM_HEX(0xEAEFF2);
        _progressBar.emptyLineStrokeColor = UICOLOR_FROM_HEX(0xEAEFF2);
        
        _progressBar.progressColor = kThemeColorMain;
        _progressBar.progressStrokeColor = kThemeColorMain;
        
    }
    return _progressBar;
        
}

- (UILabel *)doneValueLabel{
    if (!_doneValueLabel) {
        _doneValueLabel = [UILabel labelWithText:@"0" textColor:UICOLOR_FROM_HEX(0x3C74CE) font:FONT_SFUI_X_Semibold(25)];
    }
    return _doneValueLabel;
}

#pragma mark - data -

- (void)updateViewWithModel:(ZXTaskCenterItem*)item{
//#warning &&&& test -->>>>>
//    item.certStatus = @"Expired";
//    item.credible = NO;
//#warning <<<<<<-- test &&&&

    self.taskItem = item;
    
    /**不再显示采信标志*/
//    self.statusImgView.hidden = YES;
//    if ([item.certStatus isEqualToString:@"Success"]) {
//        self.statusImgView.hidden = NO;
//    }
    
    NSString *creImgName = @"icon_task_unauthentic";
    if (item.credible) {
        if ([item.certKey isEqualToString:@"referScoreWechat"]) {
            creImgName = @"icon_task_authentic_green";
        }
        else{
            creImgName = @"icon_task_authentic_blue";
        }
    }
    [self.statusImgView setImage:UIImageNamed(creImgName) forState:UIControlStateNormal];
    
    UIImage *img = UIImageNamed(@"icon_task_aliScroe");
    UIColor *aniColor = UIColorFromHex(0x3C74CE);
    
    if ([item.certKey isEqualToString:@"referScoreWechat"]) {
        aniColor = kThemeColorMain;
        img = UIImageNamed(@"icon_task_wxScroe");
        
        [self.uploadBtn setBackgroundImage:GradientImageHoriz(@[UIColorFromHex(0x00B050),UIColorFromHex(0x00C35A)]) forState:UIControlStateNormal];
    }
    else{
        [self.uploadBtn setBackgroundImage:GradientImageHoriz(@[UIColorFromHex(0x3C74CE),UIColorFromHex(0x5886E2)]) forState:UIControlStateNormal];
    }
    
    self.doneValueLabel.textColor = aniColor;
    self.doneValueDesLabel.textColor = aniColor;
    
    self.doneValueLabel.text = [NSString stringWithFormat:@"%.0f",[self scoreWithItem:item]];
    self.doneValueDesLabel.text = item.certTitle;

    NSArray *limitScores = [self limitScoresWithItem:item];
    
    CGFloat maxScore = ((NSNumber*)(limitScores.lastObject)).floatValue;
    CGFloat minScore = ((NSNumber*)(limitScores.firstObject)).floatValue;

    self.progressBar.maxValue = maxScore;
    self.progressBar.value = minScore;
    self.progressBar.progressColor = aniColor;
    self.progressBar.progressStrokeColor = aniColor;
    
    self.uploadBtn.hidden = NO;
    if ([item.certStatus isEqualToString:@"Success"]) {
        self.uploadBtn.hidden = YES;
    }
    else{//Expired
        
    }

    if (!_animating) {
        self.animating = YES;
        [UIView animateWithDuration:0.01 animations:^{
            self.progressBar.value = minScore;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.progressBar.value = [self scoreWithItem:item];
            } completion:^(BOOL finished) {
                self.animating = NO;
            }];
        }];
    }
    


//    if([item.certStatus isEqualToString:@"Success"]){
//
//
//    }
//    else if([item.certStatus isEqualToString:@"Fail"]){
//        self.uploadView.hidden = self.uploadingView.hidden = NO;
//        self.flagLab.hidden = NO;
//
//        [self.imgView sd_setImageWithURL:GetString(item.url).URLByCheckCharacter placeholderImage:img];
//
//        self.titleLab.text = item.certTitle;
//        [self.uploadBtn setTitle:item.certStatusDesc forState:UIControlStateNormal];
//    }
//    else{ //@"NotDone" && @"Expired"
//        self.uploadView.hidden = NO;
//
//        [self.imgView sd_setImageWithURL:GetString(item.url).URLByCheckCharacter placeholderImage:img];
//
//        self.titleLab.text = item.certTitle;
//        [self.uploadBtn setTitle:item.certStatusDesc forState:UIControlStateNormal];
//    }

}

#pragma mark - action methods -

- (void)statusIconClicked{
    
    if (!self.taskItem.credible) {
        ToastShow(@"用\"一键跳转支付宝/微信\"方式可获得采信标识，如您为找到，则可能是您的机型/版本目前无法支持");
    }
    
}

#pragma mark - help methods -

- (NSArray*)limitScoresWithItem:(ZXTaskCenterItem*)item{
    /**
     微信支付分最高850分,最低300分
     芝麻信用分最低 350 分最高 950 分
     */
    CGFloat wxMaxScore = 850;
    CGFloat wxMinScore = 300;
    CGFloat aliMaxScore = 950;
    CGFloat aliMinScore = 350;
    
    CGFloat maxScore = 0;
    CGFloat minScore = 0;

    if ([item.certKey isEqualToString:@"referScoreWechat"]) {
        maxScore = wxMaxScore;
        minScore = wxMinScore;
    }
    else if([item.certKey isEqualToString:@"referScoreSesame"]){
        maxScore = aliMaxScore;
        minScore = aliMinScore;
    }
    
    return @[@(minScore),@(maxScore)];
}

- (CGFloat)scoreWithItem:(ZXTaskCenterItem*)item{
    NSArray *limitScores = [self limitScoresWithItem:item];
    
    CGFloat maxScore = ((NSNumber*)(limitScores.lastObject)).floatValue;
    CGFloat minScore = ((NSNumber*)(limitScores.firstObject)).floatValue;
    
    CGFloat score = item.score;

    score = score > maxScore ? maxScore : score;
    score = score < minScore ? minScore : score;
    
    return score;
}


@end
