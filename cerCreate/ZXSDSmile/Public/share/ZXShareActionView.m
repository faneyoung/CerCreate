//
//  ZXShareActionView.m
//  ZXSDSmile
//
//  Created by Fane on 2020/12/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXShareActionView.h"
#import <UMShare/UMShare.h>
//#import <UIView+YYAdd.h>
#import "UIView+help.h"
#import "CoverBackgroundView.h"

static NSString *const kShareTitleImage = @"图文分享";
static NSString *const kShareTitleWx = @"微信好友";
static NSString *const kShareTitleWxCircle = @"朋友圈";
static NSString *const kShareTitleCopyLink = @"复制邀请链接";

@interface ZXShareActionView ()
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray *shareConfigs;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDesc;

@end

@implementation ZXShareActionView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.shareDesc = @"每月预支工资50%，仅需一份早餐的费用";
        self.thumImage = APPIcon;
        self.shareType = ZXShareTypeDefault;
    }
    return self;
}

- (void)setShareConfigs:(NSArray *)shareConfigs{
    _shareConfigs = shareConfigs;
    [self layoutViewWithConfigs:shareConfigs];
}

- (void)layoutViewWithConfigs:(NSArray*)configs{
    [self removeAllSubviews];
    self.clipsToBounds = YES;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH(), ShareViewHeight());

    UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
    contentView.backgroundColor = UIColor.whiteColor;
    [contentView addRoundedCornerWithRadius:16 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self addSubview:contentView];
    
    UIView *titleContainerView = [[UIView alloc] init];
    [contentView addSubview:titleContainerView];
    [titleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(54);
    }];

    UILabel *tLab = [[UILabel alloc] init];
    tLab.textAlignment = NSTextAlignmentCenter;
    tLab.font = FONT_PINGFANG_X_Medium(16);
    tLab.textColor = TextColorTitle;
    tLab.text = @"分享给好友";
    [titleContainerView addSubview:tLab];
    [tLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.inset(20);
        make.centerX.inset(0);
    }];
    
    UILabel *sepView = [[UILabel alloc] init];
    sepView.backgroundColor = kThemeColorBg;
    [titleContainerView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(1);
    }];
    
    
    CGFloat sideSpace = 22;
    CGFloat space = 10;
    CGFloat height = 70;
    CGFloat width = 47;
    __block UIView *lastView = nil;
    [configs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [obj objectForKey:@"title"];
        NSString *icon = [obj objectForKey:@"icon"];
        NSNumber *type = [obj objectForKey:@"type"];
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 10 + idx;

//        @weakify(self);
        [btn bk_addEventHandler:^(UIButton *sender) {
//            @strongify(self);
            [CoverBackgroundView hide];
            
            NSMutableDictionary *params = @{
                @"platform":type,
                @"title":GetString(self.shareTitle),
                @"desc":GetString(self.shareDesc),
                @"link":GetString(self.shareLink),
            }.mutableCopy;
            
            if ([title isEqualToString:kShareTitleCopyLink]) {
                [params  setSafeValue:self.shareLink forKey:@"text"];
            }

            [params setSafeValue:self.thumImage forKey:@"thumImage"];

            if ( self.shareType == ZXShareTypeImage &&
                self.sharedImage &&
                [title isEqualToString:kShareTitleImage]) {
                [params setSafeValue:self.sharedImage forKey:@"image"];
                if (self.shareActionBlock) {
                    self.shareActionBlock(params);
                }
                return;
            }
            
            [URLRouter routerUrlWithPath:kURLRouter_Share extra:params.copy];

        } forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).inset(80);
            make.height.mas_equalTo(height);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).inset(space);
                make.width.equalTo(lastView);
            }else{
                make.left.equalTo(contentView).inset(sideSpace);
            }
        }];
        lastView = btn;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:UIImageNamed(icon)];
        [btn addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(width);
            make.top.and.centerX.equalTo(btn);
        }];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = TextColorSubTitle;
        lab.font = FONT_PINGFANG_X(11);
        lab.text = title;
        [btn addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.bottom.equalTo(btn).inset(2);
        }];
    }];
    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).inset(sideSpace);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kThemeColorBg;
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentView);
        make.bottom.equalTo(contentView).inset(kTabBarHeight);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitleColor:TextColorSubTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT_PINGFANG_X(16);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn bk_addEventHandler:^(id sender) {
        
        [CoverBackgroundView hide];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(lineView.mas_bottom);
        make.height.mas_equalTo(kTabBarNormalHeight);
    }];
    
    self.contentView = contentView;
}

#pragma mark - data handle -

- (void)setShareModel:(id)shareModel{
    _shareModel = shareModel;

    if (![shareModel isKindOfClass:ZXShareModel.class]){
        ///其它类型model处理
        return;
    }
    
    ZXShareModel *model = (ZXShareModel*)shareModel;
    self.shareTitle = model.title;
    self.shareDesc = model.desc;
    self.shareLink = model.link;
    self.thumImage = model.thumImage;
    self.sharedImage = model.image;

}

-(void)setShareType:(ZXShareType)shareType{
    _shareType = shareType;
    
    /*
     @{@"title":@"QQ好友",
     @"icon":@"icon_share_qq",
     @"type":@(UMSocialPlatformType_QQ)
     },
     @{@"title":@"微博",
       @"icon":@"icon_share_sina",
       @"type":@(UMSocialPlatformType_Sina)
     }
     */

    NSArray *type = nil;
    if (shareType == ZXShareTypeDefault) {
        type = @[
            @{@"title":kShareTitleWx,
              @"icon":@"icon_share_wechat",
              @"type":@(UMSocialPlatformType_WechatSession)
            },
            @{@"title":kShareTitleWxCircle,
              @"icon":@"icon_share_timeline",
              @"type":@(UMSocialPlatformType_WechatTimeLine)
            },
            @{@"title":kShareTitleCopyLink,
              @"icon":@"icon_promotionShare_link",
              @"type":@(-2),
            },
        ];
    }
    else if(shareType == ZXShareTypeImage){
        type = @[
            @{@"title":kShareTitleImage,
              @"icon":@"icon_share_imageAndText",
              @"type":@(UMSocialPlatformType_WechatSession)
            },
            @{@"title":kShareTitleWx,
              @"icon":@"icon_share_wechat",
              @"type":@(UMSocialPlatformType_WechatSession)
            },
            @{@"title":kShareTitleWxCircle,
              @"icon":@"icon_share_timeline",
              @"type":@(UMSocialPlatformType_WechatTimeLine)
            },
            @{@"title":kShareTitleCopyLink,
              @"icon":@"icon_promotionShare_link",
              @"type":@(-2),
            },
        ];

    }
    
    self.shareConfigs = type;
}

#pragma mark - util methods -

- (void)showViewAnimated:(BOOL)animated{
    CoverBackgroundView *cover = [CoverBackgroundView instanceWithContentView:self mode:CoverViewShowModeBottom viewMake:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.height.mas_equalTo(ShareViewHeight());
    }];
    cover.bgViewUserEnable = NO;
}

- (void)hidViewAnimated:(BOOL)animated{
    [CoverBackgroundView hide];
}

#pragma mark - acton methods -

- (void)cancelBtnDidClicked:(UIButton *)sender{
    [CoverBackgroundView hide];
}


@end
