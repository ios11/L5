//
//  PRKAppDelegate.h
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRKAppMonitor.h"

@interface PRKAppDelegate : UIResponder <UIApplicationDelegate, PRKAppMonitor>

@property (strong, nonatomic) UIWindow *window;

@end

