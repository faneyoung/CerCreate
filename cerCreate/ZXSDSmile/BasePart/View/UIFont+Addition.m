//
//  UIFont+Addition.m
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import "UIFont+Addition.h"

ZXSDFontStyle const ZXSDFontStyleThin = @"Thin";
ZXSDFontStyle const ZXSDFontStyleLight = @"Light";
ZXSDFontStyle const ZXSDFontStyleRegular = @"Regular";
ZXSDFontStyle const ZXSDFontStyleMedium = @"Medium";
ZXSDFontStyle const ZXSDFontStyleSemibold = @"Semibold";

ZXSDFontStyle const ZXSDFontStyleBold = @"Bold";
ZXSDFontStyle const ZXSDFontStyleExtraBold = @"ExtraBold";
ZXSDFontStyle const ZXSDFontStyleHeavy = @"Heavy";

@implementation UIFont (Addition)

+ (UIFont *)PFFont:(CGFloat)fontSize
{
    return [self PFFont:fontSize style:(ZXSDFontStyleRegular)];
}

+ (UIFont *)PFFont:(CGFloat)fontSize
             style:(ZXSDFontStyle)style
{
    NSString *fontName = [NSString stringWithFormat:@"PingFangSC-%@", style];
    return [self ZXSDFontWithName:fontName fontSize:fontSize];
}

+ (UIFont *)SFFont:(CGFloat)fontSize
{
    return [self SFFont:fontSize style:(ZXSDFontStyleMedium)];
}

+ (UIFont *)SFFont:(CGFloat)fontSize
             style:(ZXSDFontStyle)style
{
    NSString *fontName = [NSString stringWithFormat:@"SFUIDisplay-%@", style];
    return [self ZXSDFontWithName:fontName fontSize:fontSize];
}


+ (UIFont *)ZXSDFontWithName:(NSString *)fontName
                   fontSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
    
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    
    return font;
}

@end
