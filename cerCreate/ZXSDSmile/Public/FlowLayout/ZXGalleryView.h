//
//  ZXGalleryView.h
//  ZXSDSmile
//
//  Created by Fane on 2021/4/19.
//  Copyright © 2021 Smile Financial. All rights reserved.
//

#import "ZXBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class ZXGalleryView;

@protocol GalleryViewDelegate <NSObject>

@optional;
-(void)gallaryView:(ZXGalleryView*)galleryView didSelectedRowAtIndex:(NSInteger)index;


@end

@interface ZXGalleryView : ZXBaseView

@property (nonatomic, assign) CGSize itemSize;


@property(nonatomic,weak) id<GalleryViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSString *placeholdImage;
@property (nonatomic, assign) BOOL hideTimer;

/**
 构造函数 frame随self的高度

 @param frame frame
 @param space 两边的间隔
 @return self
 */
-(instancetype)initWithFrame:(CGRect)frame space:(CGFloat)space;
-(instancetype)initWithFrame:(CGRect)frame itemSize:(CGSize)itemSize space:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
