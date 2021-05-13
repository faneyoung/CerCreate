//
//  ZXShareActionView.h
//  ZXSDSmile
//
//  Created by Fane on 2020/12/21.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXShareModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZXShareTypeDefault,
    ZXShareTypeImage,
} ZXShareType;

typedef void(^ShareActionBlock)(id data);


static inline CGFloat ShareViewHeight(){
    return 170+kTabBarHeight;
}

@interface ZXShareActionView : UIView
@property (nonatomic, strong) NSString *shareLink;
///图文分享image，对应thumImage
@property (nonatomic, strong) id thumImage;
///图片分享image，对应image
@property (nonatomic, strong) id sharedImage;


@property (nonatomic, assign) ZXShareType shareType;
@property (nonatomic, strong) id shareModel;

@property (nonatomic, strong) ShareActionBlock shareActionBlock;

- (void)showViewAnimated:(BOOL)animated;
- (void)hidViewAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
