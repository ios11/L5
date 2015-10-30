//
//  NSError+PRKDomain.h
//  PhotoPark
//
//  Created by Pavel Osipov on 24.09.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "NSError+PRKInfrastructure.h"
#import "PRKCloudTypes.h"

/// Domain-specific errors.
@interface NSError (PRKDomain)

/// Type of the cloud, which is issued an error during interaction. May be nil.
@property (nonatomic, readonly) NSNumber *prk_cloudType;

/// @brief Helper initializer for authorization errors.
/// @param cloudType Type of the cloud, which is issued an error during interaction.
/// @param reason NSError instance which was interpreted as an authorization error.
/// @return Localized error with PRKErrorDomain, which ID is equal to PRKAuthorizationErrorID.
+ (NSError *)prk_authorizationErrorWithCloudType:(PRKCloudType)cloudType reason:(NSError *)reason;

/// @brief General purpose initializer for all cloud interaction errors.
/// @param ID Mandatory error's identifier.
/// @param cloudType Type of the cloud, which is issued an error during interaction.
/// @param userInfo Optional additional parameters of the error.
/// @remark Error's identifier will be used as a key in NSError localization table.
/// @return Localized error with PRKErrorDomain and specified identifier.
+ (NSError *)prk_errorWithID:(NSString *)ID cloudType:(PRKCloudType)cloudType userInfo:(NSDictionary *)userInfo;

@end
