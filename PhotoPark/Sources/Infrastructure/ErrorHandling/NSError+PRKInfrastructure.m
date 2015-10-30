//
//  NSError+PRKInfrastructure.m
//  PhotoPark
//
//  Created by Pavel Osipov on 16.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "NSError+PRKInfrastructure.h"
#import "NSString+PRKInfrastructure.h"
#import <POSRx/NSException+POSRx.h>

NSString * const PRKErrorDomain = @"net.pavelosipov.PhotoParkErrorDomain";
NSString * const PRKErrorDescriptionKey = @"PRKDescription";

static NSString * const PRKErrorIDKey = @"PRKErrorID";
static NSString * const PRKErrorHTTPStatusCodeKey = @"PRKHTTPStatusCode";

static NSString * const PRKUnknownErrorID = @"UnknownError";
static NSString * const PRKInternalErrorID = @"InternalError";
static NSString * const PRKSystemErrorID = @"SystemError";
static NSString * const PRKNetworkErrorID = @"NetworkError";
static NSString * const PRKServerErrorID = @"ServerError";

@implementation NSError (PRKInfrastructure)

- (NSString *)prk_ID {
    NSParameterAssert([self p_isPhotoParkError]);
    if (![self p_isPhotoParkError]) {
        return PRKUnknownErrorID;
    }
    NSString *ID = self.userInfo[PRKErrorIDKey];
    return (ID ?: PRKUnknownErrorID);
}

- (NSURL *)prk_hostURL {
    return [self p_propertyWithKey:NSURLErrorKey];
}

- (NSNumber *)prk_HTTPStatusCode {
    return [self p_propertyWithKey:PRKErrorHTTPStatusCodeKey];
}

+ (NSError *)prk_internalErrorWithFormat:(NSString *)format, ... {
    POSRX_CHECK(format);
    va_list args;
    va_start(args, format);
    NSString *description = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return [self prk_errorWithID:PRKInternalErrorID userInfo:@{PRKErrorDescriptionKey : description}];
}

+ (NSError *)prk_systemErrorWithReason:(NSError *)reason {
    NSDictionary *userInfo;
    if (reason) {
        userInfo = @{NSUnderlyingErrorKey : reason};
    }
    return [self prk_errorWithID:PRKSystemErrorID userInfo:userInfo];
}

+ (NSError *)prk_systemErrorWithFormat:(NSString *)format, ... {
    POSRX_CHECK(format);
    va_list args;
    va_start(args, format);
    NSString *description = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return [self prk_errorWithID:PRKSystemErrorID userInfo:@{PRKErrorDescriptionKey : description}];
}

+ (NSError *)prk_networkErrorWithReason:(NSError *)reason {
    POSRX_CHECK([reason.userInfo[NSURLErrorKey] isKindOfClass:NSURL.class]);
    return [self prk_errorWithID:PRKNetworkErrorID userInfo:@{NSUnderlyingErrorKey : reason}];
}

+ (NSError *)prk_serverErrorWithURL:(NSURL *)URL HTTPStatusCode:(NSInteger)statusCode {
    POSRX_CHECK(URL);
    return [self prk_errorWithID:PRKServerErrorID userInfo:@{NSURLErrorKey : URL,
                                                             PRKErrorHTTPStatusCodeKey : @(statusCode)}];
}

+ (NSError *)prk_serverErrorWithURL:(NSURL *)URL format:(NSString *)format, ... {
    POSRX_CHECK(URL);
    POSRX_CHECK(format);
    va_list args;
    va_start(args, format);
    NSString *description = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return [self prk_errorWithID:PRKServerErrorID userInfo:@{NSURLErrorKey : URL,
                                                             PRKErrorDescriptionKey : description}];
}

+ (NSError *)prk_errorWithID:(NSString *)ID userInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *info = userInfo ? [userInfo mutableCopy] : [NSMutableDictionary new];
    info[PRKErrorIDKey] = [ID copy];
    info[NSLocalizedDescriptionKey] = [ID prk_localizedWith:@"NSError"];
    return [[NSError alloc] initWithDomain:PRKErrorDomain code:0 userInfo:info];
}

#pragma mark Private

- (id)p_propertyWithKey:(NSString *)key {
    for (NSError *error = self; error != nil; error = error.userInfo[NSUnderlyingErrorKey]) {
        id value = error.userInfo[key];
        if (value) {
            return value;
        }
    }
    return nil;
}

- (BOOL)p_isPhotoParkError {
    return [self.domain isEqualToString:PRKErrorDomain];
}

@end
