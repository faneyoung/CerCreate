//
//  UIFont+Addition.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *ZXSDFontStyle NS_STRING_ENUM;

FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleThin;
FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleLight;
FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleRegular;
FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleMedium;
FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleSemibold;

FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleBold;
FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleExtraBold;

FOUNDATION_EXPORT ZXSDFontStyle const ZXSDFontStyleHeavy;

@interface UIFont (Addition)

/**
 font:'PingFangSC-Medium'

 font:'PingFangSC-Semibold'

 font:'PingFangSC-Light'

 font:'PingFangSC-Ultralight'

 font:'PingFangSC-Regular'

 font:'PingFangSC-Thin'
 */
+ (UIFont *)PFFont:(CGFloat)fontSize;
+ (UIFont *)PFFont:(CGFloat)fontSize
             style:(ZXSDFontStyle)style;

/**
 font:'SFUIDisplay-Regular'

 font:'SFUIDisplay-Bold'

 font:'SFUIDisplay-Thin'
     
 font:'SFUIDisplay-Medium'

 font:'SFUIDisplay-Heavy'

 font:'SFUIDisplay-Ultralight'

 font:'SFUIDisplay-Semibold'

 font:'SFUIDisplay-Light'

 font:'SFUIDisplay-Black'
 */
+ (UIFont *)SFFont:(CGFloat)fontSize;
+ (UIFont *)SFFont:(CGFloat)fontSize
             style:(ZXSDFontStyle)style;


+ (UIFont *)ZXSDFontWithName:(NSString *)fontName
                    fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
