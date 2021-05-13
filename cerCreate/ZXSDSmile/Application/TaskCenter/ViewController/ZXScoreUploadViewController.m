//
//  ZXScoreUploadViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/1/22.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXScoreUploadViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "UITableView+help.h"
#import "CoverBackgroundView.h"

//vc
#import "ZXResultNoteViewController.h"
#import "ZXScreenshotDesViewController.h"


//views
#import "ZXHomeLoanNoteCell.h"
#import "ZXScoreStepCell.h"
#import "ZXScoreImageUploadCell.h"

#import "ZXScoreUploadModel.h"
#import "EPNetworkManager.h"

static NSString * const kAliScorePagePath = @"alipays://platformapi/startapp?appId=20000118";
static NSString * const kWXScorePagePath = @"alipays://platformapi/startapp?appId=20000118";

static NSString * const kBroadcastUploadExtension = @"com.zxsd.smile.ios.app.record";
static NSString * const kGroupIdentifier = @"group.com.zxsd.smile.ios.app";

#import <ReplayKit/ReplayKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZXReplayKitManager.h"

#import "ZXAppGroupManager.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeNote,
    SectionTypeStep0,
    SectionTypeStep1,
    SectionTypeUpload,
    SectionTypeAll
};

@interface ZXScoreUploadViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) ZXScoreUploadModel *scoreModel;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSDictionary *scoreImgMetaData;
@property (nonatomic, strong) NSDictionary *nameImgMetaData;

@property (nonatomic, strong) UIImageView *imgView;

@property(nonatomic,strong)AVPlayerViewController* moviePlayer;
@property(nonatomic,strong)NSString* videoPath;
@property (nonatomic, strong) UIButton *broadcastBtn;
@property (nonatomic, strong) NSArray *allImages;

@property (nonatomic, assign) Float64 curProgress;

@property (nonatomic, strong) UIView *rpPickerView;

@end

@implementation ZXScoreUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableInteractivePopGesture = YES;
    
    NSString *title = @"芝麻信用分";
    if ([self.taskItem.certKey isEqualToString:@"referScoreWechat"]) {
        title  = @"微信支付分";
    }
    self.title = title;
    
    [self.tableView registerNibs:@[
        NSStringFromClass(ZXHomeLoanNoteCell.class),
        NSStringFromClass(ZXScoreStepCell.class),
        NSStringFromClass(ZXScoreImageUploadCell.class),
    ]];
    
    [self updateConfirmBtnStatus];
    
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 74;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
    }
    return _tableView;
}

#pragma mark - data handle -
- (ZXScoreUploadModel *)scoreModel{
    if (!_scoreModel) {
        _scoreModel = [[ZXScoreUploadModel alloc] init];
    }
    
    _scoreModel.type = self.taskItem.certKey;
    
    return _scoreModel;
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SectionTypeNote) {
        if (![self shouldShowTips]) {
            return 0;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeNote) {
        ZXHomeLoanNoteCell *cell = [ZXHomeLoanNoteCell instanceCell:tableView];
        [cell updateWithData:@"薪朋友承诺，严格保障您的隐私安全"];
        cell.cancelNoteBlock = ^{
            [self hidTipItemView];
            [self.tableView reloadData];
        };
        return cell;
    }
    else if(indexPath.section == SectionTypeStep0){
        ZXScoreStepCell *cell = [ZXScoreStepCell instanceCell:tableView];
       
        ZXScoreStepItemModel *item = [ZXScoreStepItemModel itemWithType:self.taskItem.certKey step:0];

        [cell updateWithData:item];

        return cell;
    }
    else if(indexPath.section == SectionTypeStep1){
        ZXScoreStepCell *cell = [ZXScoreStepCell instanceCell:tableView];
        
        ZXScoreStepItemModel *item = [ZXScoreStepItemModel itemWithType:self.taskItem.certKey step:1];
        [cell updateWithData:item];
        
        return cell;
    }
    else if(indexPath.section == SectionTypeUpload){
        ZXScoreImageUploadCell *cell = [ZXScoreImageUploadCell instanceCell:tableView];
        [cell updateViewWithData:self.scoreModel];
        
        @weakify(self);
        cell.uploadBtnClickBlock = ^(UIButton * _Nonnull btn, ZXScoreUploadModel*  _Nonnull data) {
            @strongify(self);
            self.fileType = [self fileTypeWithBtn:btn];
            if (btn.tag == 1) {
                [self showUploadDesAuthView:data];
            }
            else{
                [self showUploadDesView:data btn:btn];
            }
        };

        return cell;
    }
    
    
    return [tableView defaultReuseCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SectionTypeNote ||
        section == SectionTypeStep0) {
        return 0;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == SectionTypeAll-1) {
        return 100;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [tableView defaultHeaderFooterView];
    view.backgroundColor = kThemeColorBg;
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [tableView defaultHeaderFooterView];
    view.backgroundColor = UIColor.whiteColor;

    UIButton *confirmBtn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(16) title:@"确认"];
    confirmBtn.backgroundColor = TextColorDisable;
    [view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(30);
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(confirmBtn, 22, 0.01, UIColor.whiteColor);
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = confirmBtn;
    [self updateConfirmBtnStatus];
    return view;
}

#pragma mark - action methods -
- (void)confirmBtnClicked:(UIButton*)btn{
    if (!IsValidString(self.scoreModel.scoreUrl)) {
        ToastShow(@"请先上传信用分截图");
        return;
    }
    if (!IsValidString(self.scoreModel.nameUrl)) {
        ToastShow(@"请先上传信用分截图");
        return;
    }

    [self requestReferScoreConfirm];
}

#pragma mark - help methods -

- (NSString *)fileTypeWithBtn:(UIButton*)btn{
    
    NSString *type = @"";
    if ([self.scoreModel isAliScore]) {
        type = @"sesameScore";
        if (btn.tag == 1) {
            type = @"sesameName";
        }
    }
    else{
        type = @"wechatScore";
        if (btn.tag == 1) {
            type = @"wechatName";
        }
    }
    
    return type;
}

- (BOOL)updateConfirmBtnStatus{
    
    BOOL sta = YES;
    
    if (!IsValidString(self.scoreModel.scoreUrl)) {
        sta = NO;
    }
    if (!IsValidString(self.scoreModel.nameUrl)) {
        sta = NO;
    }
    
    UIImage *selBtnBgImage = GradientImageThemeBlue();
    if ([self.scoreModel.type isEqualToString:@"referScoreWechat"]) {
        selBtnBgImage = GradientImageThemeMain();
    }
    
    if (sta) {
        [self.confirmBtn setBackgroundImage:selBtnBgImage forState:UIControlStateNormal];
    }
    else{
        [self.confirmBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    self.confirmBtn.userInteractionEnabled = sta;
    
    return sta;
}

- (BOOL)shouldShowTips{
    if ([self.taskItem.certKey isEqualToString:@"referScoreSesame"]) {
        if ([ZXSDCurrentUser currentUser].userHideScoreNoteAli) {
            return NO;
        }

    }
    else if([self.taskItem.certKey isEqualToString:@"referScoreWechat"]){
        if ([ZXSDCurrentUser currentUser].userHideScoreNoteWX) {
            return NO;
        }
    }
    
    return YES;
}

- (void)hidTipItemView{
    if ([self.taskItem.certKey isEqualToString:@"referScoreSesame"]) {
        [ZXSDCurrentUser currentUser].userHideScoreNoteAli = YES;
    }
    else if([self.taskItem.certKey isEqualToString:@"referScoreWechat"]){
        [ZXSDCurrentUser currentUser].userHideScoreNoteWX = YES;
    }
}


- (void)showUploadDesView:(ZXScoreUploadModel*)uploadModel btn:(UIButton*)uploadBtn{
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    
    UIView *titleView = [[UIView alloc] init];
    [containerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(44);
    }];
    UIButton *cancelbtn = [UIButton buttonWithNormalImage:UIImageNamed(@"icon_close") highlightedImage:UIImageNamed(@"icon_close")];
    [titleView addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.inset(0);
        make.width.mas_equalTo(56);
    }];
    [cancelbtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title = uploadModel.uploadDesTitle;
    if (uploadBtn.tag == 1) {
        title = uploadModel.uploadDesAuthTitle;
    }
    UILabel *titleLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(16) text:title];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    NSString *desshotScreenImg = uploadModel.uploadDesShotScreen;
    if (uploadBtn.tag == 1) {
        desshotScreenImg = uploadModel.uploadDesShotScreenAuth;
    }
    
    UIImageView *screenImgView = [[UIImageView alloc] init];
    screenImgView.image = UIImageNamed(desshotScreenImg);
    [containerView addSubview:screenImgView];
    [screenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom).inset(24);
        make.right.inset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(260);
    }];
    
    UIView *desItemsView = [[UIView alloc] init];
    [containerView addSubview:desItemsView];
    
    NSArray *uploadItems = uploadModel.uploadDesItems;
    if (uploadBtn.tag == 1) {
        uploadItems = uploadModel.uploadDesAuthItems;
    }
    
    CGFloat itemHeight = 47.0;
    
    [desItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(screenImgView);
        make.left.inset(0);
        make.right.mas_equalTo(screenImgView.mas_left);
        make.height.mas_equalTo(uploadItems.count*itemHeight);
    }];

    [uploadItems enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *lab = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:TextColorTitle font:FONT_PINGFANG_X(15) text:obj];
        [desItemsView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.inset(itemHeight*idx);
            make.left.right.inset(20);
            make.height.mas_equalTo(itemHeight);
        }];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = kThemeColorLine;
        [desItemsView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(lab);
            make.bottom.mas_equalTo(lab);
            make.height.mas_equalTo(1);
        }];

    }];
    
    UILabel *noteLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(19) text:@"如何找到我"];
    [containerView addSubview:noteLab];
    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(desItemsView.mas_top).inset(10);
        make.left.inset(20);
        make.height.mas_equalTo(26);
    }];

    UIButton *selBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(16) title:@"从手机相册选择" textColor:TextColorSubTitle];
    selBtn.backgroundColor = TextColorDisable;
    [containerView addSubview:selBtn];
    [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.bottom.inset(kBottomSafeAreaHeight+16);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(selBtn, 22, 0.01, UIColor.whiteColor);
    [selBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *selBtnBgImage = GradientImageThemeBlue();
    NSString *scoreBtnTitle = @"一键跳转支付宝";
    if ([uploadModel.type isEqualToString:@"referScoreWechat"]) {
        selBtnBgImage = GradientImageThemeMain();
        scoreBtnTitle = @"一键跳转微信";
    }
    
    if (@available(iOS 12.0, *)) {
        [containerView addSubview:self.rpPickerView];
    }
    
    UIButton *scoreBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(16) title:scoreBtnTitle textColor:UIColor.whiteColor];
    [scoreBtn setBackgroundImage:selBtnBgImage forState:UIControlStateNormal];
    [containerView addSubview:scoreBtn];
    [scoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(selBtn.mas_top).inset(16);
        make.left.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(scoreBtn, 22, 0.01, UIColor.whiteColor);
    
    if (@available(iOS 12.0, *)) {
        [self.rpPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(scoreBtn).inset(0);
        }];
    }

    @weakify(self);
    [scoreBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        
        if (@available(iOS 12.0, *)) {
        }
        else{
            ToastShow(@"您的手机系统版本过低，如果想使用此功能，请您升级系统版本至iOS12以上");
            return;

        }
        
        if ([uploadModel.type isEqualToString:@"referScoreWechat"]) {
            
            if(![URLRouter isWxInstalled]){
                return;
            }
            
        }
        else{
            if (![URLRouter isAlipayInstalled]) {
                return;
            }
        }
        
        [CoverBackgroundView hide];

        ZXScreenshotDesViewController *desVC = [[ZXScreenshotDesViewController alloc] init];
        desVC.type = uploadModel.type;
        [self.navigationController pushViewController:desVC animated:YES];
        @weakify(self);
        desVC.desVCConfirmBlock = ^() {
            @strongify(self);
            [self.broadcastBtn sendActionsForControlEvents:UIControlEventAllEvents];
        };

    } forControlEvents:UIControlEventTouchUpInside];
    
    
    //配置record和监听
    CGFloat contentHeight = 518+kBottomSafeAreaHeight;
    if (@available(iOS 12.0, *)) {
        [self setupRecord];
    }
    else{
        scoreBtn.hidden = YES;
        contentHeight = 458.0;
        [selBtn setBackgroundImage:selBtnBgImage forState:UIControlStateNormal];
        [selBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    
    if (![kSourceChannel isEqualToString:@"appstore"]) {
        contentHeight = 458.0;
        scoreBtn.hidden = YES;
        [selBtn setBackgroundImage:selBtnBgImage forState:UIControlStateNormal];
        [selBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    
    self.rpPickerView.hidden = scoreBtn.hidden;
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:containerView mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(16);
        make.height.mas_equalTo(contentHeight);
        
    }];
    cover.bgViewUserEnable = NO;
    [containerView addRoundedCornerWithRadius:8 corners:UIRectCornerTopLeft | UIRectCornerTopRight];

}

- (void)showUploadDesAuthView:(ZXScoreUploadModel*)uploadModel{
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    
    UIView *titleView = [[UIView alloc] init];
    [containerView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(44);
    }];
    UIButton *cancelbtn = [UIButton buttonWithNormalImage:UIImageNamed(@"icon_close") highlightedImage:UIImageNamed(@"icon_close")];
    [titleView addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.inset(0);
        make.width.mas_equalTo(56);
    }];
    [cancelbtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    
    NSString *title = uploadModel.uploadDesAuthTitle;

    UILabel *titleLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(16) text:title];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    NSString *desshotScreenImg = uploadModel.uploadDesShotScreenAuth;

    UIImageView *screenImgView = [[UIImageView alloc] init];
    screenImgView.image = UIImageNamed(desshotScreenImg);
    [containerView addSubview:screenImgView];
    [screenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom).inset(24);
        make.centerX.offset(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(260);
    }];
    
    UILabel *noteLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(19) text:@"如何找到我"];
    [containerView addSubview:noteLab];
    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(screenImgView.mas_bottom).inset(16);
        make.centerX.offset(0);
        make.height.mas_equalTo(26);
    }];
    
    UIView *desItemsView = [[UIView alloc] init];
    [containerView addSubview:desItemsView];
    [desItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteLab.mas_bottom).inset(16);
        make.left.right.inset(0);
    }];
    
    
    NSArray *uploadItems = uploadModel.uploadDesAuthItems;
    int count = (int)uploadItems.count;

    CGFloat margin = 38.0;
    CGFloat arrowWidth = 4;
    CGFloat arrowHeight = 24;
    
    CGFloat itemWith = (SCREEN_WIDTH() - 2*margin - count*arrowWidth)/count;
    CGFloat itemHeight = 40.0;

    [uploadItems enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *lab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X(13) text:obj];
        lab.numberOfLines = 0;
        [desItemsView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.inset(0);
            make.width.mas_equalTo(itemWith);
            make.height.mas_equalTo(itemHeight);
            make.left.inset(margin + (itemWith+arrowWidth)*idx);
        }];
        
        if (idx != count -1) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = UIImageNamed(@"icon_uploadDes_arrow");
            [desItemsView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lab.mas_right);
                make.centerY.offset(0);
                make.width.mas_equalTo(4);
                make.height.mas_equalTo(arrowHeight);
            }];
        }
        
    }];
    
    UIImage *selBtnBgImage = GradientImageThemeBlue();
    if ([uploadModel.type isEqualToString:@"referScoreWechat"]) {
        selBtnBgImage = GradientImageThemeMain();
    }
    
    UIButton *selBtn = [UIButton buttonWithFont:FONT_PINGFANG_X_Medium(16) title:@"从手机相册选择" textColor:UIColor.whiteColor];
    [selBtn setBackgroundImage:selBtnBgImage forState:UIControlStateNormal];
    [containerView addSubview:selBtn];
    [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.bottom.inset(kBottomSafeAreaHeight+16);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(selBtn, 22, 0.01, UIColor.whiteColor);
    [selBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:containerView mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(16);
        make.height.mas_equalTo(518+kBottomSafeAreaHeight);
        
    }];
    cover.bgViewUserEnable = NO;
    [containerView addRoundedCornerWithRadius:8 corners:UIRectCornerTopLeft | UIRectCornerTopRight];

}



#pragma mark - UIImagePickerControllerDelegate -

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    // 快速点的时候会回调多次
    @weakify(self)
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            LoadingManagerShow();
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//            NSData *data = UIImageJPEGRepresentation(image, 0.5);
//            UIImageOrientation imageOrientation = image.imageOrientation;
//
//            if(imageOrientation != UIImageOrientationUp){
//                CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
//                CGFloat aspectWidth = image.size.width * aspectRatio;
//                CGFloat aspectHeight = image.size.height * aspectRatio;
//
//                UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
//                [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
//                image = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//            }
            
            [self metaDataFromAssetLibrary:info reAspectImage:image];
        }
    }];
}

#pragma mark - data handle 1 -
- (void)uploadReferScoreWithImage:(UIImage *)image{
    [self uploadReferScoreWithImage:image isIdentify:NO];
}
- (void)uploadReferScoreWithImage:(UIImage *)image isIdentify:(BOOL)isIdentify{
    
    NSString *idenStr = @"false";
    if (isIdentify) {
        idenStr = @"true";
    }
    @weakify(self);
    NSString *api = [NSString stringWithFormat:@"%@?fileType=%@&isIdentify=%@",kPath_taskUploadImage,self.fileType,idenStr];
    [[EPNetworkManager defaultManager] postAPI:api apiBasePath:MAIN_URL parameters:nil decodeClass:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        @strongify(self);
        NSData *data = UIImageJPEGRepresentation(image, 0.75);
        [formData appendPartWithFileData:data name:@"file" fileName:@"File" mimeType:@"jpg"];

        UIImage *img = [UIImage imageWithData:data];
        
        NSMutableDictionary *tmps = @{}.mutableCopy;
        [tmps setSafeValue:[NSString stringWithFormat:@"%d",(int)img.size.width] forKey:@"width"];
        [tmps setSafeValue:[NSString stringWithFormat:@"%d",(int)img.size.height] forKey:@"height"];
        [tmps setSafeValue:[NSString stringWithFormat:@"%.1luKB",data.length/1000] forKey:@"size"];

        if ([self.fileType hasSuffix:@"Name"]) {
            [tmps addEntriesFromDictionary:self.nameImgMetaData];
            self.nameImgMetaData = tmps.copy;
        }
        else if([self.fileType hasSuffix:@"Score"]){
            [tmps addEntriesFromDictionary:self.scoreImgMetaData];
            self.scoreImgMetaData = tmps.copy;
        }

    } completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);

        LoadingManagerHidden();
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        

        if (response.resultModel.code != 0) {
            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }
        
        ToastShow(@"上传成功");

        NSString *url = (NSString *)response.resultModel.data;
        
        if ([self.fileType isEqualToString:@"wechatName"] ||
            [self.fileType isEqualToString:@"sesameName"]) {
            self.scoreModel.authImg = image;
            self.scoreModel.nameUrl = url;

        }
        else if([self.fileType isEqualToString:@"wechatScore"] ||
                [self.fileType isEqualToString:@"sesameScore"]){
            self.scoreModel.cameraImg = image;
            self.scoreModel.scoreUrl = url;
        }
        
        dispatch_safe_async_main(^{
            [CoverBackgroundView hide];
            [self.tableView reloadData];
            [self updateConfirmBtnStatus];
        });
    }];
    
}

- (void)requestReferScoreConfirm{
    
    NSMutableDictionary *tmps = @{}.mutableCopy;
    
    NSString *scoreType = @"sesameScore";
    if ([self.scoreModel isWxScore]) {
        scoreType = @"wechatScore";
    }

    
    [tmps setSafeValue:scoreType forKey:@"scoreType"];
    [tmps setSafeValue:self.scoreModel.scoreUrl forKey:@"scoreUrl"];
    [tmps setSafeValue:self.scoreModel.nameUrl forKey:@"nameUrl"];
    [tmps setSafeValue:self.nameImgMetaData.yy_modelToJSONString forKey:@"nameExtra"];
    [tmps setSafeValue:self.scoreImgMetaData.yy_modelToJSONString forKey:@"scoreExtra"];

    LoadingManagerShow();
    [[EPNetworkManager defaultManager] postAPI:kPath_taskScoreConfirm parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        LoadingManagerHidden();
        
        if (error) {
            [self handleRequestError:error];
            return;
        }
        
        if (response.resultModel.code != 0) {
            if ([self appErrorWithData:response.originalContent]) {
                if (IsValidString(response.resultModel.responseMsg)) {
                    [self showToastWithText:response.resultModel.responseMsg];
                }
            }
            return;
        }
        
        
        ZXResultNoteViewController *noteVC = [[ZXResultNoteViewController alloc] init];
        NSString *msg = @"芝麻信用分页 & 账户安全页\n上传成功";
        UIImage *img = GradientImageThemeBlue();

        if ([self.scoreModel isWxScore]) {
            msg = @"微信支付分页 & 实名认证页\n上传成功";
            img = GradientImageThemeMain();
        }

        noteVC.payMessage = msg;
        noteVC.customTitle = self.scoreModel.title;
        noteVC.confirmBgImage = img;

        noteVC.resultPageType = ResultPageTypeTaskScoreUpload;

        [self.navigationController pushViewController:noteVC animated:YES];

        
    }];
    
    
}

#pragma mark - image metaData -

- (void)metaDataWithInfo:(NSMutableDictionary*)info{
    
    if ([self.fileType hasSuffix:@"Name"]) {
        self.nameImgMetaData = info.copy;
        
    }
    else if([self.fileType hasSuffix:@"Score"]){
        self.scoreImgMetaData = info.copy;
    }
}

- (void) metaDataFromAssetLibrary:(NSDictionary*)info reAspectImage:(UIImage*)reAspectImage{

    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
   __block NSMutableDictionary *tmps = @{}.mutableCopy;
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset)  {

        NSMutableDictionary *imageMetadata = nil;
        NSDictionary *metadata = asset.defaultRepresentation.metadata;
        imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:metadata];

        [tmps setSafeValue:@"jpg" forKey:@"type"];

        NSDictionary *tiff = [metadata dictionaryObjectForKey:@"{TIFF}"];
        [tmps setSafeValue:[tiff stringObjectForKey:@"Make"] forKey:@"Maker"];
        [tmps setSafeValue:[tiff stringObjectForKey:@"Model"] forKey:@"Model"];

        NSDictionary *Exif= [metadata dictionaryObjectForKey:@"{Exif}"];
        NSString *timeStr = [Exif stringObjectForKey:@"DateTimeOriginal"];
        [tmps setSafeValue:timeStr forKey:@"DateTimeOriginal"];
        NSString *UserComment = [Exif stringObjectForKey:@"UserComment"];
        [tmps setSafeValue:UserComment forKey:@
         "UserComment"];

        [self metaDataWithInfo:tmps];

        [self uploadReferScoreWithImage:reAspectImage];


    }failureBlock:^(NSError *error) {
        NSLog (@"error %@",error);
        [self uploadReferScoreWithImage:reAspectImage];

    }];
    
    
    
}


#pragma mark - record  -

- (void)setupRecord{
    if (@available(iOS 12.0, *)) {
        ((RPSystemBroadcastPickerView*)self.rpPickerView).preferredExtension = kBroadcastUploadExtension;
    }
    
    NSArray *listenerTypes = @[
        @"broadcastFinished",
        @"broadcastStartedWithSetupInfo",
    ];
    @weakify(self);

    [ZXAppGroupManager.defaultManager addListenerWithTypes:listenerTypes notifyBlock:^(NSString * _Nullable type, id  _Nullable messageObject) {
        @strongify(self);
        if ([type isEqualToString:@"broadcastStartedWithSetupInfo"]) {
            
            [ZXAppGroupManager.defaultManager writeDictionary:@{@"kGroupScoreTypeName":self.fileType} fileName:@"kGroupScoreTypeName"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self gotoAliOrWXScroePage];
            });
        }
        else if([type isEqualToString:@"broadcastFinished"]){
            NSLog(@"+++++++++++主工程响应broadcastFinished");

            NSData *imgData = [ZXAppGroupManager.defaultManager dataFromFile:@"kGroupImage"];
            UIImage *img = [UIImage imageWithData:imgData];
            
            if (img) {
                LoadingManagerShow();
                dispatch_queue_after_S(1, ^{
                    [self uploadReferScoreWithImage:img isIdentify:YES];
                });
            }
            else{
                [EasyTextView showText:@"录屏获取图片失败，请重新获取或从从手机相册获取"];
            }
        }
    }];

}



- (void)gotoAliOrWXScroePage{
    
    [(UIViewController*)ZXReplayKitManager.sharedInstance.replayKitBroadVC dismissViewControllerAnimated:NO completion:^{

    }];
    
    if ([self.fileType rangeOfString:@"wechat"].location != NSNotFound) {
        
        [URLRouter jumptoWXMiniProgramScoreCompletion:^(BOOL success) {
            NSLog(@"----------jumptoWXMiniProgramScoreCompletion");

        }];
    }
    else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAliScorePagePath] options:@{} completionHandler:^(BOOL success) {
            NSLog(@"----------openURL:[NSURL URLWithString:kAliScorePagePath");

        }];
    }
    
}


#pragma mark - views1 -

- (UIButton *)broadcastBtn{
    if (!_broadcastBtn) {
        
        __block UIButton *btn = nil;
        [self.rpPickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]){
                btn = obj;
                *stop = YES;
            }
        }];
        
        _broadcastBtn = btn;
    }
    
    return _broadcastBtn;
}


- (UIView *)rpPickerView{
    if (!_rpPickerView) {
        if (@available(iOS 12.0, *)) {
            RPSystemBroadcastPickerView *picker = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectZero];
            picker.backgroundColor = UIColor.whiteColor;
            picker.showsMicrophoneButton = NO;
            //extension的bundle id，必须要填写对
//            picker.preferredExtension = kBroadcastUploadExtension;
            _rpPickerView = picker;
            
        }
    }
    
    return _rpPickerView;
}



#pragma mark - Lazy load
- (NSString*)recordName{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kGroupIdentifier];
   NSString *recordName = [userDefaults stringForKey:@"recordname"];
//   NSDictionary* nameDic = [ZXAppGroupManager.defaultManager dictionaryFromFile:@"kRecordTypeName"];
//    NSString *recordName = [nameDic valueForKey:@"recordname"];
    return recordName;
}

- (void)setupDocPath{
    NSString *outputURL = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    self.videoPath = [[outputURL stringByAppendingPathComponent:[self recordName]] stringByAppendingPathExtension:@"mp4"];
    NSLog(@"self.videoOutPath=%@",self.videoPath);
    
//#warning --test--
//    self.videoPath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"];
//    return;
//#warning --test--
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
        [[NSFileManager defaultManager ] removeItemAtPath:self.videoPath error:nil];
    }

}

- (void)setupDocImagePath{
    NSString *outputURL = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    self.videoPath = [[outputURL stringByAppendingPathComponent:[self recordName]] stringByAppendingPathExtension:@"jpg"];
    NSLog(@"image path=%@",self.videoPath);
    
//#warning --test--
//    self.videoPath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"];
//    return;
//#warning --test--
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
        [[NSFileManager defaultManager ] removeItemAtPath:self.videoPath error:nil];
    }

}


#pragma mark - data -

- (UIImage*)shotcutOnFrameInVideoWithTime:(CGFloat)time{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.videoPath] options:nil];
    
    CMTime cmtime = asset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    Float64 inputTime = time > durationSeconds ? durationSeconds : time;
    
    //获取视频缩略图
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    CMTime requestTime;
    
    requestTime =CMTimeMakeWithSeconds(inputTime, 60);  // CMTime是表示电影时间信息的结构体，第一个参数表示是视频当前时间，第二个参数表示每秒帧数
    
    NSError*  error =nil;
    
    CMTime actualTime;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return thumbImg;

    
}

-(UIImage*)thumbnailImageWithAtTime:(NSTimeInterval)inputTime forVideo:(NSURL *)videoURL{
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    //获取视频缩略图
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    CMTime requestTime;
    
    requestTime =CMTimeMakeWithSeconds(inputTime, 60);  // CMTime是表示电影时间信息的结构体，第一个参数表示是视频当前时间，第二个参数表示每秒帧数
    
    NSError*  error =nil;
    
    CMTime actualTime;
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return thumbImg;
    
}

@end
