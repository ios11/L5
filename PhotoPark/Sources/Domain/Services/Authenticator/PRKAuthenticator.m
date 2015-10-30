//
//  PRKDropboxAuthenticator.m
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAuthenticator.h"
#import "NSError+PRKDomain.h"

static NSString * const PRKAuthenticationErrorID = @"AuthnticationError";

@implementation NSError (PRKAuthenticator)

+ (NSError *)prk_authenticationErrorForCloud:(PRKCloudType)cloudType {
    NSString *description = [NSString stringWithFormat:@"%@ authentication failed.", PRKStringFromCloudType(cloudType)];
    return [self prk_errorWithID:PRKAuthenticationErrorID
                       cloudType:cloudType
                        userInfo:@{PRKErrorDescriptionKey : description}];
}

@end
