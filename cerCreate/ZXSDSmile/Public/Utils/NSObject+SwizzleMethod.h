//
//  NSObject+SwizzleMethod.h
//  ZXSDSmile
//
//  Created by chrislos on 2020/9/17.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SwizzleMethod)

+ (void)swizzleInstaceMethodWithOriginSel:(SEL)originSel swizzleSel:(SEL)swizzleSel;

@end

NS_ASSUME_NONNULL_END
