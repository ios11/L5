//
//  UIDevice+PRKInfrastructure.h
//  PhotoPark
//
//  Created by Pavel Osipov on 30.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (PRKInfrastructure)

/// @return Human readable name of the platform, for ex. "iPhone 5s (GSM)"
+ (NSString *)prk_platformName;

@end
