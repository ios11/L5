//
//  NSString+PRKInfrastructure.m
//  PhotoPark
//
//  Created by Pavel Osipov on 16.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "NSString+PRKInfrastructure.h"

@implementation NSString (PRKInfrastructure)

- (NSString *)prk_localized {
    return [self prk_localizedWith:@"Localizable"];
}

- (NSString *)prk_localizedWith:(NSString *)table {
     return [[NSBundle mainBundle] localizedStringForKey:self value:self table:table];
}

@end
