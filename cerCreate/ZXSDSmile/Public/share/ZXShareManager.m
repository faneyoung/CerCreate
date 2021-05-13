//
//  ZXShareManager.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXShareManager.h"
#import <Photos/Photos.h>

#import "CoverBackgroundView.h"

#import "ZXShareActionView.h"
#import "ZXShareModel.h"
#import "ZXShareInfoModel.h"

@interface ZXShareManager ()
@property (nonatomic, strong) NSDictionary *shareData;

@end

@implementation ZXShareManager


SingletonImp(ZXShareManager, sharedManager);

//+ (void)destroy{
//    onceToken = 0;
//    sharedManager = nil;
//}

- (void)showShareViewWithData:(NSDictionary*)data{

    if (!IsValidDictionary(data)) {
        return;
    }
    
    ZXShareActionView *shareView = [[ZXShareActionView alloc] init];
    shareView.shareType = ZXShareTypeDefault;

    ZXShareModel *model = [[ZXShareModel alloc] init];
    model.title = GetStrDefault([data stringObjectForKey:@"title"], @"薪朋友");
    model.desc = GetString([data stringObjectForKey:@"describe"]);
    model.link = GetString([data stringObjectForKey:@"shareUrl"]);
    shareView.shareModel = model;
    
    [shareView showViewAnimated:YES];
}

- (void)showImageShareViewWithData:(NSDictionary*)data{
    
    if (!IsValidDictionary(data)) {
        return;
    }
    
    ZXShareActionView *shareView = [[ZXShareActionView alloc] init];
    shareView.shareType = ZXShareTypeImage;

    ZXShareModel *model = [[ZXShareModel alloc] init];
    model.title = GetStrDefault([data stringObjectForKey:@"title"], @"薪朋友");
    model.desc = GetString([data stringObjectForKey:@"describe"]);
    model.link = GetString([data stringObjectForKey:@"shareUrl"]);
    model.image = [data stringObjectForKey:@"qrCodeUrl"];
    shareView.shareModel = model;
    [shareView showViewAnimated:YES];
    
    shareView.shareActionBlock = ^(NSDictionary*  _Nonnull data) {
//                    [URLRouter routerUrlWithPath:kURLRouter_Share extra:params.copy];
        NSLog(@"----------shareView.shareActionBlock,data=%@",data.yy_modelToJSONString);
        self.shareData = data;
        [self bigImageShareView];

    };
    
}

- (void)showImageShareViewWithInfo:(ZXShareInfoModel*)data{
    
    [self showImageShareViewWithData:data.yy_modelToJSONObject];
}


#pragma mark -  help -

- (void)bigImageShareView{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIButton *backBtn = [UIButton buttonWithNormalImage:UIImageNamed(@"icon_nav_back_white") highlightedImage:UIImageNamed(@"icon_nav_back_white")];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [bgView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(kStatusBarHeight);
        make.left.inset(16);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(44);
    }];
    [backBtn bk_addEventHandler:^(id sender) {
        [CoverBackgroundView hide];
    } forControlEvents:UIControlEventTouchUpInside];

    id image = [self.shareData stringObjectForKey:@"image"];
    if (!image) {
        image = [self.shareData objectForKey:@"image"];
    }
    
    CGFloat shareContainerHeight = 170 + kBottomSafeAreaHeight;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(kNavigationBarHeight+30);
        make.left.right.inset(30);
        make.bottom.inset(shareContainerHeight);
    }];
    if ([image isKindOfClass:NSString.class]) {
        [imgView sd_setImageWithURL:((NSString*)image).URLByCheckCharacter];
    }
    else if([image isKindOfClass:UIImage.class]){
        imgView.image = UIImageNamed(image);
    }
    
    UIView *shareView = [[UIView alloc] init];
    [bgView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(shareContainerHeight);
    }];
    
    CGFloat margin = 20;
    CGFloat space = 10;
    int maxCount = 3;
    CGFloat itemWidth = (SCREEN_WIDTH()-2*margin-(maxCount-1)*space)/maxCount;
    CGFloat itemHeight = 70;

    UIView *inviteItem = [self itemViewWithImage:@"icon_share_wechat" title:@"微信好友"];
    [shareView addSubview:inviteItem];
    [inviteItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(30);
        make.left.inset(margin);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
    }];

    UIView *wxCircelItem = [self itemViewWithImage:@"icon_share_timeline" title:@"朋友圈"];
    [shareView addSubview:wxCircelItem];
    [wxCircelItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(30);
        make.centerX.offset(0);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
    }];

    UIView *linkItem = [self itemViewWithImage:@"icon_share_download" title:@"保存图片"];
    [shareView addSubview:linkItem];
    [linkItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(30);
        make.right.inset(margin);
        make.width.mas_equalTo(itemWidth);
        make.height.mas_equalTo(itemHeight);
    }];
    
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:bgView mode:CoverViewShowModeCenter viewMake:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
}

- (UIView*)itemViewWithImage:(NSString*)img title:(NSString*)title{
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = UIImageNamed(img);
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(10);
        make.width.height.mas_equalTo(47);
        make.centerX.offset(0);
    }];
    
    
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = TextColorSubTitle;
    lab.font = FONT_PINGFANG_X(11);
    lab.text = title;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).inset(10);
        make.centerX.offset(0);
    }];
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
    
    if ([title isEqualToString:@"微信好友"]) {
        btn.tag = 101;
    }
    else if([title isEqualToString:@"朋友圈"]){
        btn.tag = 102;
    }
    else if([title isEqualToString:@"保存图片"]){
        btn.tag = 103;
    }
    [btn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}
#pragma mark - action -

- (void)itemBtnClicked:(UIButton*)sender{
    LoadingManagerShow();
    [CoverBackgroundView hide];
    if (sender.tag == 101) {
        NSMutableDictionary *tmps = [[NSMutableDictionary alloc] initWithDictionary:self.shareData];
        [tmps setSafeValue:@(1) forKey:@"platform"];

        [URLRouter routerUrlWithPath:kURLRouter_Share extra:tmps.copy];
        LoadingManagerHidden();

    }
    else if(sender.tag == 102){
        NSMutableDictionary *tmps = [[NSMutableDictionary alloc] initWithDictionary:self.shareData];
        [tmps setSafeValue:@(2) forKey:@"platform"];
        [URLRouter routerUrlWithPath:kURLRouter_Share extra:tmps.copy];
        LoadingManagerHidden();

    }
    else if(sender.tag == 103){

        id image = [self.shareData objectForKey:@"image"];
        if ([image isKindOfClass:UIImage.class]) {
            [self saveImageToAlbum:image];
            return;
        }
        UIImageView *localImgView = [[UIImageView alloc] init];
        [localImgView sd_setImageWithURL:((NSString*)image).URLByCheckCharacter completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image) {
                [self saveImageToAlbum:image];
            }
        }];

    }

}

#pragma mark -  image handle -

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    LoadingManagerHidden();
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;

    }else{
        msg = @"保存图片成功" ;
    }
    
    ToastShow(msg);
    
}
- (void)saveImageToAlbum:(UIImage*)img{
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


@end
