//
//  ZXTaskReferenceItemCell.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXTaskReferenceItemCell.h"
#import "MBCircularProgressBarView.h"

#import "ZXTaskCenterModel.h"

@interface ZXTaskReferenceItemCell ()

@property (weak, nonatomic) IBOutlet UIView *uploadView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UILabel *flagLab;


@property (weak, nonatomic) IBOutlet UIView *uploadingView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadingImgView;
@property (weak, nonatomic) IBOutlet UILabel *uploadingTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UIView *completedView;
@property (nonatomic, strong) MBCircularProgressBarView *progressBar;
@property (nonatomic, strong) UILabel *doneValueLabel;
@property (nonatomic, strong) UILabel *doneValueDesLabel;
@property (nonatomic, assign) BOOL animating;


@property (nonatomic, strong) CALayer *aniLayer;

@property (nonatomic, strong) ZXTaskCenterItem *taskItem;

@end

@implementation ZXTaskReferenceItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubViews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 20;
    CGFloat space = 7;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*margin-space)/2;

    CGFloat width = 80;
    CGFloat height = 80;
    self.aniLayer.frame = CGRectMake((itemWidth-width)/2, CGRectGetMidY(self.uploadingView.frame)-height+3, width, height);
}

- (void)setupSubViews{
    ViewBorderRadius(self.flagLab, 2, 0.01, UIColor.whiteColor);
    self.flagLab.hidden = YES;
    
    CGFloat margin = 20;
    CGFloat space = 7;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*margin-space)/2;

    CGFloat width = 80;
    CGFloat height = 80;

    CALayer *layer = [CALayer layer];
    layer.backgroundColor = UIColorFromHex(0x3C74CE).CGColor; //圆环底色
    layer.frame = CGRectMake((itemWidth-width)/2, 5, width, height);
    
    //创建一个圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:20 startAngle:0 endAngle:M_PI*2 clockwise:YES];
     
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 3;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.8;
    shapeLayer.lineCap = @"round";
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
     
    //颜色渐变
//    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[UIColor redColor].CGColor,(id)[UIColor whiteColor].CGColor, nil];
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.shadowPath = bezierPath.CGPath;
//    gradientLayer.frame = CGRectMake(width/2, width/2, width/2, width/2);
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1, 0);
//    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
//    [layer addSublayer:gradientLayer]; //设置颜色渐变
    [layer setMask:shapeLayer]; //设置圆环遮罩
    [self.uploadingView.layer addSublayer:layer];
    self.aniLayer = layer;
    self.aniLayer.hidden = YES;
    
    
    //已完成
    [self.completedView addSubview:self.progressBar];
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(30);
        make.left.right.inset(22);
        make.bottom.inset(30);
    }];
    
    [self.progressBar addSubview:self.doneValueLabel];
    [self.doneValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressBar).inset(30);
        make.centerX.equalTo(self.progressBar);
    }];
    
    UILabel *descLabel = [UILabel labelWithText:@"芝麻信用分" textColor:UICOLOR_FROM_HEX(0x3C74CE) font:FONT_PINGFANG_X(11)];
    [self.progressBar addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressBar);
        make.top.equalTo(self.doneValueLabel.mas_bottom).inset(0);
    }];
    self.doneValueDesLabel = descLabel;

}

- (MBCircularProgressBarView *)progressBar
{
    if (!_progressBar) {
        _progressBar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH() - 148)/2.0, 20, 148, 148)];
        _progressBar.progressLineWidth = 7;
        _progressBar.emptyLineWidth = 7;
        _progressBar.backgroundColor = [UIColor whiteColor];
        _progressBar.progressCapType = 1;
        _progressBar.emptyCapType = 1;
        _progressBar.showValueString = NO;
        
        _progressBar.emptyLineColor = UICOLOR_FROM_HEX(0xEAEFF2);
        _progressBar.emptyLineStrokeColor = UICOLOR_FROM_HEX(0xEAEFF2);
        
        _progressBar.progressColor = kThemeColorMain;
        _progressBar.progressStrokeColor = kThemeColorMain;
    }
    return _progressBar;
        
}

- (UILabel *)doneValueLabel
{
    if (!_doneValueLabel) {
        _doneValueLabel = [UILabel labelWithText:@"0" textColor:UICOLOR_FROM_HEX(0x3C74CE) font:FONT_SFUI_X_Semibold(28)];
    }
    return _doneValueLabel;
}


#pragma mark - data -

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

- (void)updateViewWithModel:(ZXTaskCenterItem*)item{
    self.taskItem = item;
    self.aniLayer.hidden = YES;
    self.flagLab.hidden = YES;
    
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
    

    if([item.certStatus isEqualToString:@"Submit"] ||
       [item.certStatus isEqualToString:@"humanCheck"]){
        self.uploadView.hidden = YES;
        self.uploadingView.hidden = NO;
        
        [self.uploadingImgView sd_setImageWithURL:GetString(item.url).URLByCheckCharacter placeholderImage:img];
        
        self.uploadingTitleLab.text = item.certTitle;
        self.desLab.text = item.certTitleDesc;
        
        [self layerAnimation:YES color:aniColor];
    }
    else if([item.certStatus isEqualToString:@"Success"]){
        self.uploadView.hidden = self.uploadingView.hidden = YES;
        
        self.doneValueDesLabel.text = item.certTitle;
        
        NSArray *limitScores = [self limitScoresWithItem:item];
        
        CGFloat maxScore = ((NSNumber*)(limitScores.lastObject)).floatValue;
        CGFloat minScore = ((NSNumber*)(limitScores.firstObject)).floatValue;

        self.progressBar.maxValue = maxScore;
        self.progressBar.value = minScore;
        self.progressBar.progressColor = aniColor;
        self.progressBar.progressStrokeColor = aniColor;
        self.doneValueLabel.text = [NSString stringWithFormat:@"%.0f",[self scoreWithItem:item]];
        
        if (_animating) {
            return;
        }
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
    else if([item.certStatus isEqualToString:@"Fail"]){
        self.uploadView.hidden = self.uploadingView.hidden = NO;
        self.flagLab.hidden = NO;

        [self.imgView sd_setImageWithURL:GetString(item.url).URLByCheckCharacter placeholderImage:img];
        
        self.titleLab.text = item.certTitle;
        [self.uploadBtn setTitle:item.certStatusDesc forState:UIControlStateNormal];
        
    }
    else{ //@"NotDone" && @"Expired"
        self.uploadView.hidden = NO;

        [self.imgView sd_setImageWithURL:GetString(item.url).URLByCheckCharacter placeholderImage:img];
        
        self.titleLab.text = item.certTitle;
        [self.uploadBtn setTitle:item.certStatusDesc forState:UIControlStateNormal];

    }

}
#pragma mark - action -

- (IBAction)uploadBtnClicked:(UIButton *)sender {
    
    
}

#pragma mark - help methods -
- (void)layerAnimation:(BOOL)show color:(UIColor*)col{
    self.aniLayer.hidden = !show;
    if (show) {
        self.aniLayer.backgroundColor = col.CGColor;
        
        CABasicAnimation *rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation2.fromValue = [NSNumber numberWithFloat:0];
        rotationAnimation2.toValue = [NSNumber numberWithFloat:6.0*M_PI];
        rotationAnimation2.autoreverses = NO;
        rotationAnimation2.repeatCount = MAXFLOAT;
        rotationAnimation2.beginTime = 0.1; //延时执行，注释掉动画会同时进行
        rotationAnimation2.duration = 5;
        [self.aniLayer addAnimation:rotationAnimation2 forKey:@"aniLay"];
    }
}


@end
