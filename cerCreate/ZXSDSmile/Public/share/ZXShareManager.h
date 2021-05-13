//
//  ZXShareManager.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/8.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXShareInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZXShareManager : NSObject

SingletonInterface(ZXShareManager, sharedManager);
///文字链接分享
- (void)showShareViewWithData:(NSDictionary*)data;
///带图片分享的actionView
- (void)showImageShareViewWithData:(NSDictionary*)data;
///带图片分享的actionView
- (void)showImageShareViewWithInfo:(ZXShareInfoModel*)data;

@end

NS_ASSUME_NONNULL_END
