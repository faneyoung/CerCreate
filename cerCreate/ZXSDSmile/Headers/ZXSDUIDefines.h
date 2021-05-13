//
//  ZXSDUIDefines.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/7/10.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef ZXSDUIDefines_h
#define ZXSDUIDefines_h

#import "UIFont+Addition.h"
#import "UITableViewCell+BottomLine.h"
#import "UIButton+ExpandClickArea.h"
#import "UIImage+Additions.h"

//
#define ZXSD_BARBUTTON_ITEM_FRAME CGRectMake(0.f, 0.f, 44.f, 44.f)

#pragma mark - Font
//static NSString *const Font_name_AkrobatSemiBold = @"Akrobat-SemiBold";
//static NSString *const Font_name_AkrobatBold = @"Akrobat-Bold";
//static NSString *const Font_name_AkrobatExtraBold = @"Akrobat-ExtraBold";
/////站酷庆科黄油体
//static NSString *const Font_HY = @"zcoolqingkehuangyouti-Regular";

//PingFangSC系列字体
#define FONT_PINGFANG_X(fontSize) [UIFont PFFont:fontSize]
#define FONT_PINGFANG_X_Medium(fontSize) [UIFont PFFont:fontSize style:(ZXSDFontStyleMedium)]
#define FONT_PINGFANG_X_Semibold(fontSize) [UIFont PFFont:fontSize style:(ZXSDFontStyleSemibold)]

//Akrobat

static inline UIFont *Font_customStyle(NSString*fontName,CGFloat fontSize,ZXSDFontStyle style){
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if(style){
        font = [UIFont fontWithName:[NSString stringWithFormat:@"%@-%@",fontName,style] size:fontSize];
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    return font;
}


static inline UIFont *Font_Akrobat(CGFloat fontSize,ZXSDFontStyle style){
    
    return Font_customStyle(@"Akrobat", fontSize, style);
}

static inline UIFont *Font_Songti(CGFloat fontSize,ZXSDFontStyle style){
    return Font_customStyle(@"STSongti-SC", fontSize, style);
}


///宋体

#define FONT_Songti_regular(fontSize) Font_Songti(fontSize,ZXSDFontStyleRegular)
#define FONT_Songti_bold(fontSize) Font_Songti(fontSize,ZXSDFontStyleBold)
///汉鼎简中黑 handingjianzhonghei
#define Font_handingJZH(fontSize) Font_customStyle(@"handingjianzhonghei", fontSize, nil)

#define FONT_Akrobat_regular(fontSize) Font_Akrobat(fontSize,ZXSDFontStyleRegular)
#define FONT_Akrobat_Semibold(fontSize) Font_Akrobat(fontSize,ZXSDFontStyleSemibold)
#define FONT_Akrobat_bold(fontSize) Font_Akrobat(fontSize,ZXSDFontStyleBold)
#define FONT_Akrobat_ExtraBold(fontSize) Font_Akrobat(fontSize,ZXSDFontStyleExtraBold)

// SFUIDisplay系列字体-->全局转换为Akrobat
#define FONT_SFUI_X_Regular(fontSize) [UIFont SFFont:fontSize style:ZXSDFontStyleRegular]

#define FONT_SFUI_X_Medium(fontSize) [UIFont SFFont:fontSize style:ZXSDFontStyleMedium]

#define FONT_SFUI_X_Semibold(fontSize) [UIFont SFFont:fontSize style:ZXSDFontStyleSemibold]

#define FONT_SFUI_X_Bold(fontSize) [UIFont SFFont:fontSize style:ZXSDFontStyleBold]




#pragma mark - Color
#define COMMON_APP_NAVBAR_COLOR UICOLOR_FROM_HEX(0xFAFAFA) //导航栏主题色
#define COMMON_APP_NAVBARTITLE_COLOR UICOLOR_FROM_HEX(0x333333) //导航栏标题颜色


#define MAIN_BUTTON_BACKGROUND_IMAGE [UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0x00C35A),UICOLOR_FROM_HEX(0x00B050)] direction:UIImageGradientDirectionHorizontal] //主按钮背景渐变色

#define kGradientImageYellow [UIImage resizableImageWithGradient:@[UICOLOR_FROM_HEX(0xFFDDA7),UICOLOR_FROM_HEX(0xFED185)] direction:UIImageGradientDirectionHorizontal] //背景渐变色黄

#endif /* ZXSDUIDefines_h */
