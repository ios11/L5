//
//  PRKBaseNavigationController.h
//  PhotoPark
//
//  Created by Pavel Osipov on 04.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRKAppAssembly;

@interface PRKBaseNavigationController : UINavigationController

@property (nonatomic, readonly) PRKAppAssembly *assembly;

/// The designated initializer.
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                                  assembly:(PRKAppAssembly *)assembly;

@end
