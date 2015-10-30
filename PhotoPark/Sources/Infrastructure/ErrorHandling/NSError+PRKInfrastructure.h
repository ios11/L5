//
//  NSError+PRKInfrastructure.h
//  PhotoPark
//
//  Created by Pavel Osipov on 16.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Unique string which identifies app errors.
FOUNDATION_EXTERN NSString * const PRKErrorDomain;

/// The key in error's userInfo for the string with human readable description of the problem.
FOUNDATION_EXTERN NSString * const PRKErrorDescriptionKey;

/// Domain-agnostic errors.
@interface NSError (PRKInfrastructure)

/// @brief Nonnul unique string for each type of the error, for ex. "SystemError".
@property (nonatomic, readonly) NSString *prk_ID;

/// @brief URL of the problem host. It never nil for the errors with PRKNetworkErrorID.
@property (nonatomic, readonly) NSURL *prk_hostURL;

/// @brief HTTP status code of the problem host. May be nonnull only for server communication errors.
@property (nonatomic, readonly) NSNumber *prk_HTTPStatusCode;

/// @brief Helper initializer for internal errors.
/// @param format Mandatory template string of the error's description.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKInternalErrorID.
+ (NSError *)prk_internalErrorWithFormat:(NSString *)format, ...;

/// @brief Helper initializer for errors received from iOS SDK frameworks with specified reason.
/// @param reason Optional underlying error.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKSystemErrorID.
+ (NSError *)prk_systemErrorWithReason:(NSError *)reason;

/// @brief Helper initializer for errors occured while interacting with iOS.
/// @param format Mandatory template string of the error's description.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKSystemErrorID.
+ (NSError *)prk_systemErrorWithFormat:(NSString *)format, ...;

/// @brief Helper initializer for networking errors.
/// @param reason Mandatory reason, which userInfo contains NSURL in the property with key NSURLErrorKey.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKNetworkErrorID.
+ (NSError *)prk_networkErrorWithReason:(NSError *)reason;

/// @brief Helper initializer for server communication errors.
/// @param URL Mandatory Issued URL.
/// @param statusCode HTTP status code in HTTP response.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKServerErrorID.
+ (NSError *)prk_serverErrorWithURL:(NSURL *)URL HTTPStatusCode:(NSInteger)statusCode;

/// @brief Helper initializer for server communication errors.
/// @param URL Mandatory Issued URL.
/// @param format Description of the failure handling server response.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKServerErrorID.
+ (NSError *)prk_serverErrorWithURL:(NSURL *)URL format:(NSString *)format, ...;

/// @brief General purpose initializer for all errors in the app.
/// @param ID Mandatory error's identifier.
/// @param userInfo Optional additional parameters of the error.
/// @remark Error's identifier will be used as a key in NSError localization table.
/// @return Localized error with PRKErrorDomain and specified identifier.
+ (NSError *)prk_errorWithID:(NSString *)ID userInfo:(NSDictionary *)userInfo;

@end

NS_INLINE void PRKAssignError(NSError **target, NSError *source) {
    if (target) {
        *target = source;
    }
}
