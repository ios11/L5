//
//  NSBundle+PRKPresentation.m
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "NSBundle+PRKPresentation.h"
#import <POSRx/POSRx.h>

@implementation NSBundle (PRKPresentation)

- (NSString *)prk_dropboxAppKey {
    return [self prk_objectForKey:@"PRKDropboxAppKey"];
}

- (NSString *)prk_dropboxAppSecret {
    return [self prk_objectForKey:@"PRKDropboxAppSecret"];
}

#pragma mark Private

- (NSString *)prk_objectForKey:(NSString *)key {
    id value = [self objectForInfoDictionaryKey:key];
    POSRX_CHECK_EX([value isKindOfClass:[NSString class]], @"Unexpected value for key '%@': %@", key, value);
    return value;
}

@end
