//
//  ZXBankIncomeUploadViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/3/10.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBankIncomeUploadViewController.h"
#import <YBImageBrowser.h>


#import "UITableView+help.h"
#import "CoverBackgroundView.h"

//vc
#import "ZXResultNoteViewController.h"

//views
#import "ZXHomeLoanNoteCell.h"
#import "ZXBankIncomeDesCell.h"
#import "ZXBankIncomeUploadCell.h"

#import "EPNetworkManager.h"
#import "ZXBankIncomeModel.h"
#import "ZXBankincomeUploadItemModel.h"


typedef NS_ENUM(NSUInteger, SectionType) {
    SectionTypeNote,
    SectionTypeDes,
    SectionTypeUpload,
    SectionTypeAll
};
@interface ZXBankIncomeUploadViewController () <UITableViewDelegate,UITableViewDataSource,YBImageBrowserDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL canPresentImagePicker;

@property (nonatomic, assign) int fileType;
@property (nonatomic, strong) NSString *firstImgUrl;
@property (nonatomic, strong) NSString *secImgUrl;
@property (nonatomic, strong) NSString *thirdImgUrl;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) ZXBankIncomeModel *incomeModel;

@property (nonatomic, strong) YBImageBrowser *imageBrowser;
@property (nonatomic, strong) UIView *bigImageTopView;
@property (nonatomic, strong) UILabel *pageTitleLab;

@end

@implementation ZXBankIncomeUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行收入明细截图";
    self.enableInteractivePopGesture = YES;
    
    [self requestWageDetail];
}

#pragma mark - views -
- (void)setupSubViews{
    self.tableView.backgroundColor  = kThemeColorBg;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    [self.tableView registerNibs:@[
    
        NSStringFromClass(ZXHomeLoanNoteCell.class),
        NSStringFromClass(ZXBankIncomeDesCell.class),
        NSStringFromClass(ZXBankIncomeUploadCell.class),

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

#pragma mark - data handle -
- (void)requestWageDetail{
    LoadingManagerShow();
    [EPNetworkManager.defaultManager getAPI:kPath_wageDetail parameters:nil decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
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
        
        self.incomeModel = [ZXBankIncomeModel instanceWithDictionary:response.resultModel.data];

        [self.tableView reloadData];
    }];
}

- (NSArray*)findMeStems{
    return @[
        @{@"icon_task_upload_step1":@"打开\"银行App\""},
        @{@"icon_task_upload_step2":@"点击\"我的明细\"进入随心查"},
        @{@"icon_task_upload_step3":@"点击\"对应月份工资收入\""},
        @{@"icon_task_upload_step4":@"点击\"明细详情\""},
    ];
}

- (void)uploadReferScoreWithImage:(UIImage *)image{
    
    LoadingManagerShow();
    @weakify(self);
    [[EPNetworkManager defaultManager] postAPI:kPath_wageImgUpload apiBasePath:MAIN_URL parameters:nil decodeClass:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSData *data = UIImageJPEGRepresentation(image, 0.75);
        [formData appendPartWithFileData:data name:@"file" fileName:@"File" mimeType:@"jpg"];

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
        [self updateImageUrl:url];
        
        dispatch_safe_async_main(^{
            [self.tableView reloadData];
        });
    }];
    
}

- (void)requestWageSubmit{
    
   __block NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:3];
//    [tmps addObject:self.firstImgUrl];
//    [tmps addObject:self.secImgUrl];
//    [tmps addObject:self.thirdImgUrl];
    [self.incomeModel.uploadImgItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmps addSafeObject:obj.imgUrl];
    }];
    
    LoadingManagerShow();
    [EPNetworkManager.defaultManager postAPI:kPath_wageSubmit parameters:tmps.copy decodeClass:nil completion:^(NSURLRequest * _Nullable request, EPNetworkResponse * _Nullable response, NSError * _Nullable error) {
        
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
        noteVC.payMessage = @"工资明细正在认证中 …";
        noteVC.resultPageType = ResultPageTypeWageAuthing;
        [self.navigationController pushViewController:noteVC animated:YES];
    }];
}

- (void)updateImageUrl:(NSString*)url{
    
    [self.incomeModel.uploadImgItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == self.fileType) {
            obj.imgUrl = url;
            *stop = YES;
        }
    }];
}

- (void)deleteImageUrlWithType:(int)type{
    
    [self.incomeModel.uploadImgItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == self.fileType) {
            obj.imgUrl = @"";
            *stop = YES;
        }
    }];
}



#pragma mark - action methods -
- (void)uploadBtnClicked:(int)type{
    
    self.fileType = type;

    if (self.canPresentImagePicker) {
        [self showImagePickerController];
    }
    else{
        [self showUploadDesViewWithType:type];
    }
}

- (void)confirmBtnClicked{
    
//#warning &&&& test -->>>>>
//    NSLog(@"----------current thread=%@",NSThread.currentThread);
//    ZXResultNoteViewController *noteVC = [[ZXResultNoteViewController alloc] init];
//    noteVC.payMessage = GetStrDefault(nil, @"工资明细正在认证中 …");
//    noteVC.resultPageType = ResultPageTypeWageAuthing;
//    [self.navigationController pushViewController:noteVC animated:YES];
//
//    return;
//#warning <<<<<<-- test &&&&
    __block BOOL isAll = YES;
    [self.incomeModel.uploadImgItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!IsValidString(obj.imgUrl)) {
            isAll = NO;
            *stop = YES;
        }
    }];

    if (!isAll) {
        ToastShow(@"请上传正确的图片再提交");
        return;
    }
    
    [self requestWageSubmit];
    
}

#pragma mark --UITableViewDataSource & UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionTypeAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SectionTypeNote) {
        if ([self shouldShowTips]) {
            return 1;
        }
    }
    else if(section == SectionTypeDes){
        return self.incomeModel.desItems.count;
    }
    else if(section == SectionTypeUpload){
        return 1;
    }
    
    return 0;
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
    else if(indexPath.section == SectionTypeDes){
        ZXBankIncomeDesCell *cell = [ZXBankIncomeDesCell instanceCell:tableView];
        NSArray *desItems = self.incomeModel.desItems;
        [cell updateWithData:desItems[indexPath.row]];
        cell.isBottomItem = indexPath.row == desItems.count-1;
        return cell;
    }
    else if(indexPath.section == SectionTypeUpload){
        ZXBankIncomeUploadCell *cell = [ZXBankIncomeUploadCell instanceCell:tableView];
        
        [cell updateWithData:self.incomeModel.uploadImgItems];
        
        @weakify(self);
        cell.imgItemClickedBlock = ^(int idx) {
            
            @strongify(self);
            self.fileType = idx;
            ZXBankincomeUploadItemModel *item = self.incomeModel.uploadImgItems[idx];
            if (IsValidString(item.imgUrl)) {//大图预览
                [self showImageBrowserWithIndex:idx];
            }
            else{
                [self uploadBtnClicked:idx];
            }
        };
        cell.deleteBtnClickBlock = ^(int idx) {
            @strongify(self);
            self.fileType = idx;

            [self deleteImageUrlWithType:idx];
            [self.tableView reloadData];
        };
        
        return cell;
    }
    
    return [tableView defaultReuseCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == SectionTypeUpload) {
        return 108;
    }
    
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [tableView defaultHeaderFooterView];
    footerView.backgroundColor = kThemeColorBg;
    
    if (section == SectionTypeUpload) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:MAIN_BUTTON_BACKGROUND_IMAGE forState:UIControlStateNormal];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_PINGFANG_X_Medium(15);
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.inset(20);
            make.top.bottom.inset(32);
            make.height.mas_equalTo(44);
        }];
        ViewBorderRadius(btn, 22, 0.01, UIColor.clearColor);
        [btn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.confirmBtn = btn;

        return footerView;
    }

    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UIImagePickerControllerDelegate -

- (void)showImagePickerController{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

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
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self uploadReferScoreWithImage:image];
        }
    }];
}

#pragma mark - help methods -
- (BOOL)shouldShowTips{
    if ([ZXSDCurrentUser currentUser].userHideWageUploadNote) {
        return NO;
    }

    return YES;
}

- (void)hidTipItemView{
    [ZXSDCurrentUser currentUser].userHideWageUploadNote = YES;
}

- (void)showImageBrowserWithIndex:(int)idx{
    YBImageBrowser *browser = [[YBImageBrowser alloc] init];
    
    __block NSMutableArray *imgItems = @[].mutableCopy;
    [self.incomeModel.uploadImgItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.imgUrl hasPrefix:@"http"]) {
            YBIBImageData *imgData = [YBIBImageData new];
            imgData.imageURL = obj.imgUrl.URLByCheckCharacter;
            [imgItems addObject:imgData];
        }
    }];

    browser.delegate = self;
    browser.dataSourceArray = imgItems.copy;
    browser.currentPage = idx;
   
    YBIBTopView *topView = browser.defaultToolViewHandler.topView;
    [topView.operationButton setImage:UIImageNamed(@"icon_close") forState:UIControlStateNormal];
    [topView.operationButton updateTarget:self action:@selector(previewBigImageViewDelete) forControlEvents:UIControlEventTouchUpInside];
    [browser show];
    self.imageBrowser = browser;

    UIView *topToolView = [[UIView alloc] init];
    topToolView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [topView addSubview:topToolView];
    [topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(-kStatusBarHeight);
        make.left.right.bottom.inset(0);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:UIImageNamed(@"icon_common_close_white") forState:UIControlStateNormal];
    [cancelBtn updateTarget:self action:@selector(previewBigImageViewClose) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.inset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *titleLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:UIColor.whiteColor font:FONT_PINGFANG_X(17)];
    [topToolView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.mas_equalTo(cancelBtn);
    }];
    titleLab.text = [NSString stringWithFormat:@"%d/%d",(int)self.imageBrowser.currentPage+1,(int)self.imageBrowser.dataSourceArray.count];
    self.pageTitleLab = titleLab;

    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:UIImageNamed(@"icon_common_delete_white") forState:UIControlStateNormal];
    [deleteBtn updateTarget:self action:@selector(previewBigImageViewDelete) forControlEvents:UIControlEventTouchUpInside];
    [topToolView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.inset(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(44);
    }];
}

- (void)yb_imageBrowser:(YBImageBrowser *)imageBrowser pageChanged:(NSInteger)page data:(id<YBIBDataProtocol>)data{
    self.pageTitleLab.text = [NSString stringWithFormat:@"%d/%d",(int)page+1,(int)self.imageBrowser.dataSourceArray.count];
}

- (void)previewBigImageViewClose{
    [self.imageBrowser hide];
}

- (void)previewBigImageViewDelete{
    [self.imageBrowser hide];
    
    [self.incomeModel.uploadImgItems enumerateObjectsUsingBlock:^(ZXBankincomeUploadItemModel*  _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
        
        NSString *curPageStr = [self.pageTitleLab.text componentsSeparatedByString:@"/"].firstObject;
        int curPage = curPageStr.intValue - 1;
        if (idx1 == curPage) {
            obj.imgUrl = @"";
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
}


- (void)showUploadDesViewWithType:(int)type{
    
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
    
    UILabel *titleLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(16) text:@"银行交易详情明细截图示例"];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIView *topSectionView = [[UIView alloc] init];
    [containerView addSubview:topSectionView];
    [topSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleView.mas_bottom).inset(0);
        make.left.right.inset(0);
        make.height.mas_equalTo(186);
    }];
    
    UILabel *wageTitleLab = [UILabel labelWithText:@"随心查流水" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(15)];
    [topSectionView addSubview:wageTitleLab];
    [wageTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(16);
        make.left.inset(20);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *otherwageTitleLab = [UILabel labelWithText:@"其他银行流水" textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(15)];
    [topSectionView addSubview:otherwageTitleLab];
    [otherwageTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wageTitleLab);
        make.left.mas_equalTo(wageTitleLab.mas_right).inset(15);
        make.right.inset(20);
        make.width.height.mas_equalTo(wageTitleLab);
    }];

    
    UIImageView *wageImgView = [[UIImageView alloc] init];
    wageImgView.image = UIImageNamed(@"icon_upload_wage");
    wageImgView.contentMode = UIViewContentModeCenter;
    [topSectionView addSubview:wageImgView];
    [wageImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wageTitleLab.mas_bottom).inset(16);
        make.left.inset(20);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(112);
    }];
    
    UIImageView *otherwageImgView = [[UIImageView alloc] init];
    otherwageImgView.image = UIImageNamed(@"icon_upload_otherWage");
    otherwageImgView.contentMode = UIViewContentModeCenter;
    [topSectionView addSubview:otherwageImgView];
    [otherwageImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wageImgView);
        make.left.mas_equalTo(otherwageTitleLab);
        make.width.height.mas_equalTo(wageImgView);
    }];
    
    
    UILabel *seplab = [[UILabel alloc] init];
    seplab.backgroundColor = kThemeColorBg;
    [topSectionView addSubview:seplab];
    [seplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(8);
    }];
    
    UIImageView *screenImgView = [[UIImageView alloc] init];
    screenImgView.contentMode = UIViewContentModeScaleAspectFit;
    [screenImgView sd_setImageWithURL:GetString(self.incomeModel.url).URLByCheckCharacter placeholderImage:nil];
    [containerView addSubview:screenImgView];
    [screenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSectionView.mas_bottom).inset(16);
        make.right.inset(20);
        make.width.mas_equalTo(SCREEN_WIDTH()/2-20-10);
        make.height.mas_equalTo(252);
    }];
    
    UIImageView *flagImgView = [[UIImageView alloc] init];
    flagImgView.image = UIImageNamed(@"icon_upload_right");
    [screenImgView addSubview:flagImgView];
    [flagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.mas_equalTo(24);
    }];
    
    UIView *desItemsView = [[UIView alloc] init];
    [containerView addSubview:desItemsView];
    
    NSArray *uploadItems = [self findMeStems];
    
    UILabel *noteLab = [UILabel labelWithAlignment:NSTextAlignmentCenter textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(15) text:@"如何找到我"];
    [containerView addSubview:noteLab];
    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSectionView.mas_bottom).inset(16);
        make.left.inset(20);
        make.height.mas_equalTo(18);
    }];


    [desItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteLab.mas_bottom).inset(15);
        make.left.inset(0);
        make.right.mas_equalTo(screenImgView.mas_left).inset(19);
    }];

    __block UIView *lastView = nil;
    [uploadItems enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *imgName = obj.allKeys.firstObject;
        NSString *title = obj.allValues.firstObject;
        
        UILabel *lab = [UILabel labelWithAlignment:NSTextAlignmentLeft textColor:TextColorTitle font:FONT_PINGFANG_X(13) text:title];
        lab.numberOfLines = 0;
        [desItemsView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.mas_equalTo(lastView.mas_bottom).inset(15);
            }
            else{
                make.top.mas_equalTo(noteLab.mas_bottom).inset(19);
            }
            
            make.left.inset(48);
            make.right.inset(0);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = UIImageNamed(imgName);
        [desItemsView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lab).offset(0);
            make.left.inset(20);
            make.width.height.mas_equalTo(23);
        }];

        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = kThemeColorLine;
        [desItemsView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lab.mas_bottom).inset(12);
            make.left.right.mas_equalTo(lab);

            make.height.mas_equalTo(1);
        }];
        lastView = line;

    }];
    
    

    UIButton *selBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(16) title:@"从手机相册选择" textColor:UIColor.whiteColor];
    [containerView addSubview:selBtn];
    [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.bottom.inset(kBottomSafeAreaHeight+16);
        make.height.mas_equalTo(44);
    }];
    ViewBorderRadius(selBtn, 22, 0.01, UIColor.whiteColor);
    @weakify(self);
    [selBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        [CoverBackgroundView hide];
        [self showImagePickerController];
        self.canPresentImagePicker = YES;

    } forControlEvents:UIControlEventTouchUpInside];
    
    [selBtn setBackgroundImage:GradientImageThemeMain() forState:UIControlStateNormal];

    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:containerView mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(16);
        make.height.mas_equalTo(590+kBottomSafeAreaHeight);
        
    }];
    cover.bgViewUserEnable = NO;
    [containerView addRoundedCornerWithRadius:8 corners:UIRectCornerTopLeft | UIRectCornerTopRight];

}


@end
