//
//  PRKBaseNavigationController.m
//  PhotoPark
//
//  Created by Pavel Osipov on 04.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKBaseNavigationController.h"
#import <POSRx/POSRx.h>

@implementation PRKBaseNavigationController

POSRX_DEADLY_INITIALIZER(initWithRootViewController:(UIViewController *)rootViewController)

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
                                  assembly:(PRKAppAssembly *)assembly {
    POSRX_CHECK(assembly);
    if (self = [super initWithRootViewController:rootViewController]) {
        _assembly = assembly;
    }
    return self;
}

@end
