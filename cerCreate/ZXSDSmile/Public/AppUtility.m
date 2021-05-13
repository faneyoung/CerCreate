//
//  AppUtility.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/4.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "AppUtility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "CoverBackgroundView.h"

@implementation AppUtility

#pragma mark - textView -

+ (void)textWithInputView:(UITextField *)textView maxNum:(NSInteger)limitNum{
    [AppUtility textWithInputView:textView maxNum:limitNum shouldResign:YES];
}

+ (BOOL)textWithInputView:(UITextField *)textView maxNum:(NSInteger)limitNum shouldResign:(BOOL)resign{
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length >= limitNum) {
                textView.text = [toBeString substringToIndex:limitNum];
                if (resign) {
                    [textView resignFirstResponder];
                    
                }
                
                return NO;
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length >= limitNum) {
            textView.text = [toBeString substringToIndex:limitNum];
            if (resign) {
                [textView resignFirstResponder];
            }
            
            return NO;

        }
    }
    
    return YES;
}

+ (BOOL)textWithInputView:(UITextField *)textView maxNum:(NSInteger)limitNum shouldResign:(BOOL)resign allowZH:(BOOL)zh{
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        if (!zh) {
            if (resign) {
                [textView resignFirstResponder];
                
            }
            return NO;
        }
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length >= limitNum) {
                textView.text = [toBeString substringToIndex:limitNum];
                if (resign) {
                    [textView resignFirstResponder];
                    
                }
                
                return NO;
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length >= limitNum) {
            textView.text = [toBeString substringToIndex:limitNum];
            if (resign) {
                [textView resignFirstResponder];
            }
            
            return NO;

        }
    }
    
    return YES;
}

#pragma mark - image save to album -

+ (void)saveImage:(UIImage *)img complete:(void (^)(NSError *error))complete{
    if (!img) {
        NSError *error = [[NSError alloc] init];
        
        if (complete) {
            complete(error);
        }
        return;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized/*ALAuthorizationStatusAuthorized*/) {
        NSData* imdata =  UIImagePNGRepresentation (img); // get PNG representation
        UIImage* im2 = [UIImage imageWithData:imdata]; // wrap UIImage around PNG representat
        UIImageWriteToSavedPhotosAlbum(im2,  self,
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:block:),
                                       NULL);
    }else if (status == PHAuthorizationStatusNotDetermined /*ALAuthorizationStatusNotDetermined*/){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self saveImage:img complete:complete];
        }];
    }
    else{
        NSError *error = [NSError new];
        if (complete) {
            complete(error);
        }
    }


}


- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo block:(void (^)(NSError *error))complete{
    
    if (error) {
        NSError *err = [NSError new];
        if (complete) {
            complete(err);
        }
        
        return;
    }
    
    if (complete) {
        complete(nil);
    }

}

#pragma mark - appstore comment -
+ (void)showAppstoreEvaluationView{
    
    UIView *alertView = [[UIView alloc] init];
    ViewBorderRadius(alertView, 12, 0.01, UIColor.whiteColor);
    alertView.backgroundColor = UIColor.whiteColor;
    
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = UIImageNamed(icon);
    [alertView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.centerX.offset(0);
        make.width.height.mas_equalTo(60);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = FONT_PINGFANG_X_Medium(16);
    titleLab.textColor = TextColorTitle;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"喜欢“薪朋友”吗？";
    [alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).inset(10);
        make.centerX.offset(0);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.font = FONT_PINGFANG_X(14);
    subtitleLab.textColor = TextColorTitle;
    subtitleLab.textAlignment = NSTextAlignmentCenter;
    subtitleLab.text = @"到App Store中给个好评吧~";
    [alertView addSubview:subtitleLab];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).inset(5);
        make.centerX.offset(0);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT_PINGFANG_X(16);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alertView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.inset(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.titleLabel.font = FONT_PINGFANG_X(16);
    [nextBtn setTitle:@"评价" forState:UIControlStateNormal];
    [alertView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right);
        make.right.bottom.inset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(cancelBtn);
    }];

    UILabel *hSepView = [[UILabel alloc] init];
    hSepView.backgroundColor = UICOLOR_FROM_RGB(185, 185, 185, 1);
    [alertView addSubview:hSepView];
    [hSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(51);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *vSepView = [[UILabel alloc] init];
    vSepView.backgroundColor = UICOLOR_FROM_RGB(185, 185, 185, 1);
    [alertView addSubview:vSepView];
    [vSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hSepView.mas_bottom);
        make.centerX.inset(0);
        make.bottom.inset(0);
        make.width.mas_equalTo(1);
    }];
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:alertView mode:CoverViewShowModeCenter viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(40);
        make.centerY.offset(0);
        make.height.mas_equalTo(220);
    }];
    cover.bgViewUserEnable = NO;
    
    
    
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];
    [nextBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];

        NSString *appstoreLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1517015114&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        if (SYSTEM_VERSION_GETATER_THAN(11.0)) {
            appstoreLink = @"itms-apps://itunes.apple.com/app/id1517015114?mt=8&action=write-review";
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreLink]];

    } forControlEvents:UIControlEventTouchUpInside];
}

+ (void)alertContentView:(id)content{
    
    UIView *alertView = [[UIView alloc] init];
    ViewBorderRadius(alertView, 12, 0.01, UIColor.whiteColor);
    alertView.backgroundColor = UIColor.whiteColor;
    
    UITextView *titleLab = [[UITextView alloc] init];
    titleLab.font = FONT_PINGFANG_X_Medium(14);
    titleLab.textColor = TextColorTitle;
    
    NSString *text = @"";
    if (IsValidString(content)) {
        text = content;
    }
    else if(IsValidDictionary(content)){
        text = [((NSDictionary*)content) stringObjectForKey:@"url"];
    }
    
    titleLab.text = text;
    [alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(10);
        make.left.right.inset(10);
        make.height.mas_equalTo(80);
    }];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT_PINGFANG_X(16);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alertView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.inset(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.titleLabel.font = FONT_PINGFANG_X(16);
    [nextBtn setTitle:@"test" forState:UIControlStateNormal];
    [alertView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right);
        make.right.bottom.inset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(cancelBtn);
    }];

    UILabel *hSepView = [[UILabel alloc] init];
    hSepView.backgroundColor = UICOLOR_FROM_RGB(185, 185, 185, 1);
    [alertView addSubview:hSepView];
    [hSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.inset(51);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *vSepView = [[UILabel alloc] init];
    vSepView.backgroundColor = UICOLOR_FROM_RGB(185, 185, 185, 1);
    [alertView addSubview:vSepView];
    [vSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hSepView.mas_bottom);
        make.centerX.inset(0);
        make.bottom.inset(0);
        make.width.mas_equalTo(1);
    }];
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:alertView mode:CoverViewShowModeCenter viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(40);
        make.centerY.offset(0);
        make.height.mas_equalTo(220);
    }];
    cover.bgViewUserEnable = NO;
    
    
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];

    [nextBtn bk_addEventHandler:^(id sender) {
        NSLog(@"----------");

    } forControlEvents:UIControlEventTouchUpInside];
}

+ (void)alertViewWithTitle:(NSString* __nullable)title des:(NSString* __nullable)des cancel: (void(^)(void))cancelBlock confirm:(void(^)(void))confirmBlock{

    [self.class alertViewWithTitle:title content:des cancelTitle:@"取消" cancel:cancelBlock confirmTitle:@"确定" confirm:confirmBlock];
}

+ (void)alertViewWithTitle:(NSString* __nullable)title content:(NSString* __nullable)des cancelTitle:(NSString*)cStr cancel: (void(^)(void))cancelBlock confirmTitle:(NSString*)fStr confirm:(void(^)(void))confirmBlock{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor  =UIColor.whiteColor;
    ViewBorderRadius(contentView, 8, 1, UIColor.whiteColor);
    
    UILabel *titleLab = [UILabel labelWithText:title textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(18)];
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.centerX.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *msgLab = [UILabel labelWithText:GetString(des) textColor:TextColorSubTitle font:FONT_PINGFANG_X(14)];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.numberOfLines = 0;
    [contentView addSubview:msgLab];
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).inset(20);
        make.left.right.inset(20);
    }];

    UIButton *cancelBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:cStr textColor:TextColorTitle cornerRadius:22];
    cancelBtn.backgroundColor = TextColorDisable;
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(msgLab.mas_bottom).inset(20);
        make.left.inset(20);
        make.bottom.inset(20);
        make.height.mas_equalTo(44);

    }];
    [cancelBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        if (cancelBlock) {
            cancelBlock();
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:fStr textColor:UIColor.whiteColor cornerRadius:22];
    nextBtn.backgroundColor = kThemeColorMain;
    [contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelBtn.mas_right).inset(16);
        make.bottom.inset(20);
        make.right.inset(20);
        make.width.mas_equalTo(cancelBtn);
        make.height.mas_equalTo(44);
    }];
    
    [nextBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        if (confirmBlock) {
            confirmBlock();
        }
    } forControlEvents:UIControlEventTouchUpInside];

    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:contentView mode:CoverViewShowModeCenter cancelPrevious:YES viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.centerY.offset(0);
    }];
    cover.bgViewUserEnable = NO;
}


+ (void)alertViewWithTitle:(NSString* __nullable)title des:(NSString* __nullable)des confirm:(void(^)(void))confirmBlock{
    
    [AppUtility alertViewWithTitle:title des:des confirm:@"确定" confirmBlock:confirmBlock];
}

+ (void)alertViewWithTitle:(NSString* __nullable)title des:(NSString* __nullable)des confirm:(NSString*)confirm confirmBlock:(void(^)(void))confirmBlock{
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor  =UIColor.whiteColor;
    ViewBorderRadius(contentView, 8, 1, UIColor.whiteColor);
    
    UILabel *titleLab = [UILabel labelWithText:title textColor:TextColorTitle font:FONT_PINGFANG_X_Medium(18)];
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.centerX.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *msgLab = [UILabel labelWithText:GetString(des) textColor:TextColorSubTitle font:FONT_PINGFANG_X(14)];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.numberOfLines = 0;
    [contentView addSubview:msgLab];
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).inset(20);
        make.left.right.inset(20);
    }];
    
    NSString *btnTitle = confirm;
    btnTitle = IsValidString(btnTitle) ? btnTitle : @"确定";
    UIButton *nextBtn = [UIButton buttonWithFont:FONT_PINGFANG_X(14) title:btnTitle textColor:UIColor.whiteColor cornerRadius:22];
    nextBtn.backgroundColor = kThemeColorMain;
    [contentView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(msgLab.mas_bottom).inset(20);
        make.left.bottom.right.inset(20);
        make.height.mas_equalTo(44);
    }];
    
    [nextBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
        if (confirmBlock) {
            confirmBlock();
        }
    } forControlEvents:UIControlEventTouchUpInside];

    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:contentView mode:CoverViewShowModeCenter cancelPrevious:YES viewMake:^(MASConstraintMaker *make) {
        make.left.right.inset(20);
        make.centerY.offset(0);
    }];
    cover.bgViewUserEnable = NO;
}


@end
