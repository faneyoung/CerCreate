//
//  ZXSDWebViewController.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/10/13.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "ZXSDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSDWebViewController : ZXSDBaseViewController

/// 加载url
@property (nonatomic, copy) NSString *requestURL;
/// 加载html字符串
@property (nonatomic, copy) NSString *htmlStr;
///html文件名。加载bundle中的html文件，eg: abc.html
@property (nonatomic, strong) NSString *localHtml;

@property (nonatomic, assign) BOOL showPdfBtn;


/// 是否统计
@property (nonatomic, assign) BOOL bannerAnaly;
/// 是否隐藏title
@property (nonatomic, assign) BOOL isHideTitle;

//@property (nonatomic, copy) NSString *backItemImageName;
//@property (nonatomic, assign) BOOL isShowWholeScreen;//显示全屏

@end

NS_ASSUME_NONNULL_END
