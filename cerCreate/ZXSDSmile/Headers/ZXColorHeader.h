//
//  ZXColorHeader.h
//  ZXSDSmile
//
//  Created by cashbus on 2020/11/27.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#ifndef ZXColorHeader_h
#define ZXColorHeader_h

#define RGB(R, G, B)                        ([UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f])
#define RGBA(R, G, B, A)                    ([UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A])

#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//app colors

/// 全局主题色 #E93131
#define kThemeColorMain          UIColorFromHex(0x00B050)
#define kThemeColorBlue          UIColorFromHex(0x6B9CFF)
#define kThemeColorRed           UIColorFromHex(0xF03C28)
#define kThemeColorBg            UIColorFromHex(0xF7F9FB)
#define kThemeColorOrange        UIColorFromHex(0xFD6E42)

#define kThemeColorNote          UIColorFromHex(0xFFF4D4)
#define kThemeColorYellow        UIColorFromHex(0xC8A028)
#define kThemeColorLine          UIColorFromHex(0xEAEFF2)

#define TextColorPlacehold       UIColorFromHex(0xCCD6DD)
#define TextColorDisable         kThemeColorBg


#define TextColor333333          UIColorFromHex(0x333333)
#define TextColor666666          UIColorFromHex(0x666666)
#define TextColor999999          UIColorFromHex(0x999999)
#define TextColorTitle           UIColorFromHex(0x3C465A)
#define TextColorSubTitle        UIColorFromHex(0x626F8A)
#define TextColorgray            UIColorFromHex(0xA0AfC3)

#endif /* ZXColorHeader_h */
