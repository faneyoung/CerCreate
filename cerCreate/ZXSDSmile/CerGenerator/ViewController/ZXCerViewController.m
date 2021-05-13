//
//  ZXCerViewController.m
//  ZXSDSmile
//
//  Created by Fane on 2021/5/7.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXCerViewController.h"
#import <WebKit/WebKit.h>
#import <UIView+YYAdd.h>
#import "UILabel+align.h"
#import "ZXCircleView.h"
#import "ZXYinView.h"

@interface ZXCerViewController () <UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSString *pdfPath;

@end

@implementation ZXCerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    @weakify(self);
    [self testBtns:@[@"pdf",@"export",@"show"] action:^(UIButton * _Nonnull btn) {
        @strongify(self);
        if(btn.tag == 0){

            [self exportAndSharePDF];
        }
//        else if(btn.tag == 1){
//            [self systemShare];
//        }
//        else if(btn.tag == 2){
//            NSURL *pdfURL = [NSURL fileURLWithPath:self.pdfPath];
//            NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
//
//            UIWebView *wb = [[UIWebView alloc] initWithFrame:self.view.bounds];
//            wb.backgroundColor = UIColor.brownColor;
//            [self.view addSubview:wb];
//            [wb loadRequest:request];
////            从本地获取路径进行显示PDF
////           NSURL *pdfURL = [NSURL fileURLWithPath:self.pdfPath];
////           NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
////       //    [self.myWebView setScalesPageToFit:YES];
////           [self.myWebView loadRequest:request];
//
//
//        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
#pragma mark - views -
- (void)setupSubViews{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 2;
    scrollView.minimumZoomScale = 0.01;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    self.scrollView = scrollView;
    
    
    UIView *containerView = [[UIView alloc] init];
    ViewBorderRadius(containerView, 10, 1, UIColor.brownColor);
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
        make.width.mas_equalTo(3508);
        make.height.mas_equalTo(2480);
    }];
    self.containerView = containerView;
    
    UIImageView *borderImgView = [[UIImageView alloc] init];
    borderImgView.contentMode = UIViewContentModeScaleToFill;
    borderImgView.image = UIImageNamed(@"icon_cer_border");
    [containerView addSubview:borderImgView];
    [borderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(350);
        make.left.right.inset(175);
        make.bottom.inset(150);
    }];

    UIImageView *logImgView = [[UIImageView alloc] init];
    logImgView.contentMode = UIViewContentModeScaleToFill;
    logImgView.image = UIImageNamed(@"icon_cer_logo");
    [containerView addSubview:logImgView];
    [logImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.mas_equalTo(borderImgView.mas_top).offset(40);
        make.width.mas_equalTo(370);
        make.height.mas_equalTo(400);
    }];
    
//    UILabel *cerLab = [[UILabel alloc] init];
//
//    UIFont *font = FONT_Songti_bold([self mmToPx:24]);
//
//    UIFont *font1 = [UIFont fontWithName:@"By-JOSSQ-DMF-in-BeiJing" size:24];
//    cerLab.font = font;
//
//    cerLab.textColor = UICOLOR_FROM_RGB(115.0, 102.0, 83.0, 1);
//    cerLab.text = @"营业执照";
//    [containerView addSubview:cerLab];
//    [cerLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(borderImgView).offset(300);
//        make.centerX.offset(0);
//    }];
    
    UIImageView *titleImgView = [[UIImageView alloc] init];
    titleImgView.image = UIImageNamed(@"icon_cer_title.jpg");
    [containerView addSubview:titleImgView];
    [titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(borderImgView).offset(300);
        make.centerX.offset(0);
        make.width.mas_equalTo(930);
        make.height.mas_equalTo(180);

    }];
    
    UILabel *suTitleLab = [[UILabel alloc] init];
    suTitleLab.font = FONT_Songti_regular(80);

    suTitleLab.textColor = UIColor.blackColor;
    suTitleLab.text = @"（副本）";
    [containerView addSubview:suTitleLab];
    [suTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleImgView.mas_bottom).inset(20);
        make.centerX.offset(0);
    }];
    
    UILabel *suTitleDesLab = [[UILabel alloc] init];
    suTitleDesLab.font = FONT_Songti_regular(40);

    suTitleDesLab.textColor = UIColor.blackColor;
    
    NSString *fubenNo = @"";
    if (IsValidString(self.cerModel.fuben)) {
        fubenNo = [NSString stringWithFormat:@"副本编号: %@",self.cerModel.fuben];
    }
    suTitleDesLab.text = fubenNo;
    [containerView addSubview:suTitleDesLab];
    [suTitleDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(suTitleLab.mas_right).inset(140);
        make.centerY.mas_equalTo(suTitleLab).offset(0);
    }];


    UILabel *codeLab = [[UILabel alloc] init];
    codeLab.font = FONT_Songti_regular(40);

    codeLab.textColor = UIColor.blackColor;
    codeLab.text = GetString(self.cerModel.code);
    [containerView addSubview:codeLab];
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(borderImgView).inset(224);
        make.bottom.mas_equalTo(titleImgView.mas_bottom).inset(0);
        make.height.mas_equalTo(36);
    }];
    
    UILabel *codeTitleLab = [[UILabel alloc] init];
    codeTitleLab.font = Font_handingJZH(50);

    codeTitleLab.textColor = UIColor.blackColor;
    codeTitleLab.text = @"统一社会信用代码";
    [containerView addSubview:codeTitleLab];
    [codeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeLab);
        make.bottom.mas_equalTo(codeLab.mas_top).inset(45);
        make.height.mas_equalTo(50);
    }];

    CGFloat qrWidth = 250.0;
    UIImageView *qrImageView = [[UIImageView alloc] init];
    
    NSString *qrUrl = [NSString stringWithFormat:@"http://www.gsxt.gov.cn/index.html?uniscid=%@",GetString(self.cerModel.code)];
    qrImageView.image = [self createNonInterpolatedUIImageFormCIImage:[self creatQRcodeWithUrlstring:qrUrl] withSize:qrWidth];
    [containerView addSubview:qrImageView];
    [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(borderImgView).offset(-500);
        make.bottom.mas_equalTo(suTitleLab).offset(-2);
        make.width.height.mas_equalTo(qrWidth);
    }];
    
    UILabel *qrDesLab = [[UILabel alloc] init];
    qrDesLab.font = FONT_Songti_regular(30);
    qrDesLab.numberOfLines = 0;
    qrDesLab.textColor = UIColor.blackColor;
    qrDesLab.text = @"扫描二维码登录“国家企业信用信息公示系统”了解更多登记、备案、许可、监管信息。";
    [containerView addSubview:qrDesLab];
    [qrDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qrImageView).inset(5);
        make.left.mas_equalTo(qrImageView.mas_right).inset(50);
        make.width.mas_equalTo(215);
    }];
    

    NSArray *titles = @[
        @"名称",
        @"类型",
        @"法定代表人",
    ];
    NSArray *values = @[
        GetStrDefault(self.cerModel.company, @"xx集团公司"),
        GetStrDefault(self.cerModel.type, @"有限责任公司（非自然人投资或控股的法人独资）"),
        GetStrDefault(self.cerModel.name, @" "),
    ];
    
    CGFloat titleWidth = 290;
    CGFloat titleHeight = 58;
    
    __block UILabel *lastLab = nil;
    [titles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *keyLab = [[UILabel alloc] init];
        keyLab.font = Font_handingJZH(50);
        keyLab.textColor = UIColor.blackColor;
        keyLab.text = obj;
        [containerView addSubview:keyLab];
        [keyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastLab) {
                make.top.mas_equalTo(codeLab.mas_bottom).inset(286);
            }
            else{
                make.top.mas_equalTo(lastLab.mas_bottom).inset(80);
            }
            make.left.mas_equalTo(codeLab).inset(0);
            make.height.mas_equalTo(titleHeight);
            make.width.mas_equalTo(titleWidth);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [keyLab textAlignmentLeftAndRight];
        });
        
        lastLab = keyLab;

        
        UILabel *valueLab = [[UILabel alloc] init];
        valueLab.font = FONT_Songti_regular(40);
        valueLab.textColor = UIColor.blackColor;
        valueLab.text = values[idx];
        [containerView addSubview:valueLab];
        [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(keyLab);
            make.left.mas_equalTo(keyLab.mas_right).inset(50);
        }];

    }];
    
    NSArray *rightTitles = @[
    
        @"注册资本",
        @"成立日期",
        @"营业期限",
        @"住所",

    ];
    
    NSString *yinyeTime = @"";
    if (IsValidString(self.cerModel.createTime)) {
        yinyeTime = GetStrDefault(self.cerModel.createTime, @"");
        
        NSString *invalidStr = @"";
        if (!IsValidString(self.cerModel.yingyeTime)) {
            yinyeTime = [NSString stringWithFormat:@"%@ 至 长期",self.cerModel.createTime];
        }
        else{
            yinyeTime = [NSString stringWithFormat:@"%@ 至 %@",self.cerModel.createTime,self.cerModel.yingyeTime];

        }
    }
    
    
    NSArray *rightValues = @[
    
        GetStrDefault(self.cerModel.amount, @" "),
        GetStrDefault(self.cerModel.createTime, @" "),
        GetStrDefault(yinyeTime, @" "),
        GetStrDefault(self.cerModel.address, @" "),
    ];

    __block UILabel *rightLastLab = nil;
    [rightTitles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *keyLab = [[UILabel alloc] init];
        keyLab.font = Font_handingJZH(50);
        keyLab.textColor = UIColor.blackColor;
        keyLab.text = obj;
        [containerView addSubview:keyLab];
        [keyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!rightLastLab) {
                make.top.mas_equalTo(codeLab.mas_bottom).inset(286);
            }
            else{
                make.top.mas_equalTo(rightLastLab.mas_bottom).inset(80);
            }
            make.left.mas_equalTo(suTitleDesLab).inset(0);
            make.height.mas_equalTo(titleHeight);
            make.width.mas_equalTo(titleWidth);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [keyLab textAlignmentLeftAndRight];
        });
        
        rightLastLab = keyLab;

        
        UILabel *valueLab = [[UILabel alloc] init];
        valueLab.font = FONT_Songti_regular(40);
        valueLab.textColor = UIColor.blackColor;
        valueLab.text = rightValues[idx];
        [containerView addSubview:valueLab];
        [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(keyLab);
            make.left.mas_equalTo(keyLab.mas_right).inset(50);
        }];
    }];

    UILabel *rangeTitleLab = [[UILabel alloc]init];
    rangeTitleLab.font = Font_handingJZH(50);
    rangeTitleLab.textColor = UIColor.blackColor;
    rangeTitleLab.text = @"经营范围";
    [containerView addSubview:rangeTitleLab];
    [rangeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastLab.mas_bottom).inset(80);
        make.left.mas_equalTo(lastLab);
        make.height.mas_equalTo(titleHeight);
        make.width.mas_equalTo(titleWidth);

    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rangeTitleLab textAlignmentLeftAndRight];
    });
    
    UILabel *valueLab = [[UILabel alloc] init];
    valueLab.font = FONT_Songti_regular(40);
    valueLab.textColor = UIColor.blackColor;
    valueLab.numberOfLines = 0;
    valueLab.text = GetStrDefault(self.cerModel.business, @" ");
    [containerView addSubview:valueLab];
    [valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rangeTitleLab).inset(5);
        make.left.mas_equalTo(rangeTitleLab.mas_right).inset(50);
        make.right.mas_equalTo(borderImgView).inset(1380);
    }];

    
    UILabel *registLab = [[UILabel alloc] init];
    registLab.font = Font_handingJZH(50);
    registLab.textColor = UIColor.blackColor;
    registLab.text = @"登记机关";
    [containerView addSubview:registLab];
    [registLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rightLastLab.mas_bottom).inset(380);
        make.left.mas_equalTo(titleImgView.mas_right).offset(20);
        make.width.mas_equalTo(340);
        make.height.mas_equalTo(50);
    }];
    
    CGFloat yWidth = 500;
    ZXYinView *yinView = [[ZXYinView alloc] instancetWithFrame:CGRectMake(0, 0, yWidth, yWidth)];
    [containerView addSubview:yinView];
    [yinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(borderImgView).offset(-185);
        make.bottom.mas_equalTo(borderImgView).offset(-200);
        make.width.height.mas_equalTo(yWidth);
    }];
    yinView.registUnit = self.cerModel.registUnit;
    
    
    NSString *timeStr = @"";
    if (IsValidString(self.cerModel.time)) {
        if([self.cerModel.time rangeOfString:@"."].location != NSNotFound){
            NSArray *comp = [self.cerModel.time componentsSeparatedByString:@"."];
            int month = ((NSString*)comp[1]).intValue;
            int day = ((NSString*)comp.lastObject).intValue;

            timeStr = [NSString stringWithFormat:@"%@       %d        %d",comp.firstObject,month,day];
        }
    }
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = FONT_Songti_bold(40);
    timeLab.textColor = UIColor.blackColor;
    timeLab.text = timeStr;
    [containerView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(registLab.mas_right).offset(-30);
        make.bottom.mas_equalTo(borderImgView).offset(-200);
        make.width.mas_equalTo(490);
        make.height.mas_equalTo(40);
    }];


    UILabel *timeUnitLab = [[UILabel alloc] init];
    timeUnitLab.font = Font_handingJZH(55);
    timeUnitLab.textColor = UIColor.blackColor;
    timeUnitLab.text = @"年月日";
    [containerView addSubview:timeUnitLab];
    [timeUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(borderImgView).offset(-210);
        make.bottom.mas_equalTo(borderImgView).offset(-195);
        make.width.mas_equalTo(390);
        make.height.mas_equalTo(55);
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timeLab textAlignmentLeftAndRight];
        [timeUnitLab textAlignmentLeftAndRight];
    });
    
    UILabel *websiteLab = [[UILabel alloc] init];
    websiteLab.font = FONT_Songti_regular(40);
    websiteLab.textColor = UIColor.blackColor;
    websiteLab.text = @"国家企业信用信息公示系统网址:";
    [containerView addSubview:websiteLab];
    [websiteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(borderImgView.mas_bottom).inset(25);
        make.left.mas_equalTo(borderImgView);
        make.height.mas_equalTo(40);
    }];
    UILabel *linkLab = [[UILabel alloc] init];
    linkLab.font = FONT_Songti_bold(40);
    linkLab.textColor = UIColor.blackColor;
    linkLab.text = @"http://www.gsxt.gov.cn";
    [containerView addSubview:linkLab];
    [linkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(websiteLab);
        make.left.mas_equalTo(websiteLab.mas_right).inset(10);
        make.height.mas_equalTo(40);
    }];


    UILabel *govLab = [[UILabel alloc] init];
    govLab.font = FONT_Songti_regular(50);
    govLab.textColor = UIColor.blackColor;
    govLab.text = @"国家市场监督管理总局监制";
    [containerView addSubview:govLab];
    [govLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(borderImgView.mas_bottom).inset(18);
        make.right.mas_equalTo(borderImgView).inset(15);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *noteLab = [[UILabel alloc] init];
    noteLab.numberOfLines = 2;
    noteLab.font = FONT_Songti_regular(40);
    noteLab.textColor = UIColor.blackColor;
    noteLab.text = @"市场主体应当于每年1月1日至6月30日通过国建企业信用信息公示系统报送公示年度报告。";
    [containerView addSubview:noteLab];
    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(borderImgView.mas_bottom).inset(0);
        make.centerX.offset(0);
        make.width.mas_equalTo(800);
    }];


    
}

- (CGFloat)mmToPx:(CGFloat)mm{
    CGFloat sc_w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat sc_h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat sc_s;
    CGFloat ff = [[UIScreen mainScreen] nativeBounds].size.height;
    
    if (ff == 1136) {
        sc_s = 4.0;
    }else if(ff == 1334.0){
        sc_s = 4.7;
    }else if (ff== 1920){
        sc_s = 5.5;
    }else if (ff== 2436){
        sc_s = 5.8;
    }else{
        sc_s = 3.5;
    }
    
    //1mm米的像素点
   CGFloat pmm = sqrt(sc_w * sc_w + sc_h * sc_h)/(sc_s * 25.4);//mm
    
    return pmm * mm;

}

#pragma mark - UIScrollViewDelegate -
//告诉scrollview要缩放的是哪个子控件
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

     return self.containerView;
 }



#pragma mark - final pdf convertor -

/// 导出pdf并 分享
- (void)exportAndSharePDF{
    NSData *pdfData = [self snapshotScrollViewPDF:self.scrollView];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //  二进制流写入文件
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        NSString *testDirectory = [documentsDirectory stringByAppendingString:@"/pdf"];

        //  创建目录
        [fileManger createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        //  创建文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *fileName = [formatter stringFromDate:[NSDate date]];

        NSString *testPath = [testDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",fileName]];
        
        NSLog(@"----------exportPDF path=%@",testPath);

        //  写入文件
        [fileManger createFileAtPath:testPath contents:pdfData attributes:nil];
        

        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSURL *pdfURL = [NSURL fileURLWithPath:testPath];
            
            UIActivityViewController * activity = [[UIActivityViewController alloc]initWithActivityItems:@[pdfURL] applicationActivities:nil];
            activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray* _Nullable returnedItems,NSError*_Nullable activityError) {
                if(!completed) {
                    ToastShow(@"++++++失败");

                    return;
                }
                
                if ([activityType isEqualToString:@"com.apple.CloudDocsUI.AddToiCloudDrive"]) {
                    ToastShow(@"保存成功,请到系统“文件”中查看");

                }
                else if (
                         [activityType isEqualToString:@"com.tencent.xin.sharetimeline"]||
                         [activityType isEqualToString:@"com.tencent.mqq.ShareExtension"]) {

                    ToastShow(@"分享成功");

                }
                else{
                    ToastShow(@"成功");

                }

                NSLog(@"activityType: %@,\n completed: %d,\n returnedItems:%@,\n activityError:%@",activityType,completed,returnedItems,activityError);
                
                
            };
            [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:activity animated:NO];
        });
    });
}

/** 获取tableview的长截图*/
- (NSData *)snapshotScrollViewPDF:(UIScrollView *)scrollView {
    
    // 保存原来的偏移量
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    
    // 设置截图需要的偏移量和frame
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    // 创建临时view，并且把要截图的view添加到临时view上面
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
    [scrollView removeFromSuperview];
    [tempView addSubview:scrollView];
    
    // 对临时view进行截图
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // yykit方法
    NSData *data = [tempView snapshotPDF];
    
    // 恢复截图view原来的状态
    [scrollView removeFromSuperview];
    [self.view addSubview:scrollView];
    scrollView.contentOffset = savedContentOffset;
    
    // 如果原来是frame布局，需要设置frame，如果是Auto layout需要再次进行Auto layout布局。
    scrollView.frame = savedFrame;
    //        [scrollView mas_makeConstraints:^(MASConstraintMaker *make)     {
    //            make.edges.equalTo(self);
    //        }];
    return data;
}

#pragma mark - qr create -
- (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - test -

- (void)addPdfSaveBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 70, 30);
    btn.backgroundColor = kThemeColorMain;
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_SFUI_X_Medium(18);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    ViewBorderRadius(btn, 8, 1, UIColor.whiteColor);
    
    [btn bk_addEventHandler:^(id sender) {
        [self savePDF];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

}

/// 保存view页面为pdf
- (void)savePDF{
    
    NSData *data = [self converToPDF];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    NSString *path = [NSHomeDirectory()    stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.pdf",fileName]];

    BOOL result = [data writeToFile:path atomically:YES];
    NSLog(@"----------pdfpath=%@",path);

    if (result) {//"保存成功"
        [EasyTextView showText:@"保存成功"];
        self.pdfPath = path;

    }
    else{//"保存失败";
        [EasyTextView showText:@"保存失败"];
        self.pdfPath = nil;
    }
     
//     从本地获取路径进行显示PDF
//    NSURL *pdfURL = [NSURL fileURLWithPath:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
////    [self.myWebView setScalesPageToFit:YES];
//    [self.myWebView loadRequest:request];
}

-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];

    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();


    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData

    [aView.layer renderInContext:pdfContext];

    // remove PDF rendering context
    UIGraphicsEndPDFContext();

    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);

    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];

    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
}



- (NSData *)converToPDF{

    UIViewPrintFormatter *fmt = [self.scrollView viewPrintFormatter];

    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];

    [render addPrintFormatter:fmt startingAtPageAtIndex:0];

    CGRect page;

    page.origin.x=0;

    page.origin.y=0;

    page.size.width=self.scrollView.contentSize.width;

    page.size.height=self.scrollView.contentSize.height;

    CGRect printable=CGRectInset( page, 0, 0 );

    [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];

    [render setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];

    NSMutableData * pdfData = [NSMutableData data];

    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );

    for (NSInteger i=0; i < [render numberOfPages]; i++)

    {

        UIGraphicsBeginPDFPage();

        CGRect bounds = UIGraphicsGetPDFContextBounds();

        [render drawPageAtIndex:i inRect:bounds];

    }

    UIGraphicsEndPDFContext();

    return pdfData;

}

- (void)systemShare{
    NSURL* file = [NSURL fileURLWithPath:self.pdfPath];
    
    UIActivityViewController * activity = [[UIActivityViewController alloc]initWithActivityItems:@[file] applicationActivities:nil];
    
    activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray* _Nullable returnedItems,NSError*_Nullable activityError) {
        if(!completed) {
            ToastShow(@"++++++失败");

            return;
        }
        
        if ([activityType isEqualToString:@"com.apple.CloudDocsUI.AddToiCloudDrive"]) {
            ToastShow(@"保存成功,请到系统“文件”中查看");

        }
        else if (
                 [activityType isEqualToString:@"com.tencent.xin.sharetimeline"]||
                 [activityType isEqualToString:@"com.tencent.mqq.ShareExtension"]) {

            ToastShow(@"分享成功");

        }
        else{
            ToastShow(@"成功");

        }

        NSLog(@"activityType: %@,\n completed: %d,\n returnedItems:%@,\n activityError:%@",activityType,completed,returnedItems,activityError);
        
        
    };
    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:activity animated:NO];
    
}
@end
