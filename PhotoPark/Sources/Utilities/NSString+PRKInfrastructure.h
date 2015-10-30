//
//  NSString+PRKInfrastructure.h
//  PhotoPark
//
//  Created by Pavel Osipov on 16.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PRKInfrastructure)

/// @return Localized string from Localizable.strings table.
- (NSString *)prk_localized;

/// @return Localized string from specified table.
- (NSString *)prk_localizedWith:(NSString *)table;

@end
