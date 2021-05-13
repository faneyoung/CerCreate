//
//  UIImageView+help.m
//  ZXSDSmile
//
//  Created by Fane on 2021/4/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "UIImageView+help.h"
#import <SDWebImage.h>


@implementation UIImageView (help)
- (void)setImgWithUrl:(NSString*)url{
    
    [self setImgWithUrl:url completed:nil];
    
}

- (void)setImgWithUrl:(NSString*)url completed:(nullable void (^)(UIImage*))completedBlock{
    self.contentMode = UIViewContentModeCenter;
    self.image = UIImageNamed(@"icon_placeholer");

    if (!IsValidString(url) ||
        ![url hasPrefix:@"http"]) {
        
        if (completedBlock) {
            completedBlock(nil);
        }
        
        return;
    }
    
    [self sd_setImageWithURL:url.URLByCheckCharacter placeholderImage:UIImageNamed(@"icon_placeholer") options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.image = image;
            self.contentMode = UIViewContentModeScaleToFill;
            
        }
        
        if (completedBlock) {
            completedBlock(image);
        }
        
    }];


}

@end
