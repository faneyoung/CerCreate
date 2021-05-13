//
//  AppDelegate.h
//  ZXSDSmile
//
//  Created by Jacques on 2020/6/2.
//  Copyright © 2020 Smile Financial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSDBaseTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (nonatomic, strong) ZXSDBaseTabBarController *tabBarController;

@property (nonatomic, strong) NSData *deviceToken;

+ (instancetype)appDelegate;

@end

