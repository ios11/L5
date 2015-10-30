//
//  NSError+PRKDomain.m
//  PhotoPark
//
//  Created by Pavel Osipov on 24.09.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "NSError+PRKDomain.h"

static NSString * const PRKCloudTypeKey = @"PRKCloudType";
static NSString * const PRKAuthorizationErrorID = @"AuthorizationError";

@implementation NSError (PRKDomain)

- (NSNumber *)prk_cloudType {
    return self.userInfo[PRKCloudTypeKey];
}

+ (NSError *)prk_authorizationErrorWithCloudType:(PRKCloudType)cloudType reason:(NSError *)reason {
    return (reason
            ? [self prk_errorWithID:PRKAuthorizationErrorID cloudType:cloudType userInfo:@{NSUnderlyingErrorKey : reason}]
            : [self prk_errorWithID:PRKAuthorizationErrorID cloudType:cloudType userInfo:nil]);
}

+ (NSError *)prk_errorWithID:(NSString *)ID cloudType:(PRKCloudType)cloudType userInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *extendedUserInfo = [userInfo mutableCopy];
    if (!extendedUserInfo) {
        extendedUserInfo = [NSMutableDictionary new];
    }
    extendedUserInfo[PRKCloudTypeKey] = @(cloudType);
    return [self prk_errorWithID:ID userInfo:extendedUserInfo];
}

@end
