//
//  PSAppDelegate.h
//  PSDictionaryToObjectParser
//
//  Created by Tomasz Kwolek on 29.08.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSViewController;

@interface PSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PSViewController *viewController;

@end
