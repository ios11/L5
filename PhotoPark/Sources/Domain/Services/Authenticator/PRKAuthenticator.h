//
//  PRKCloudClient.h
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <POSRx/POSRx.h>
#import "PRKCloudTypes.h"

@class UIViewController;

/// Authenticates user in the Cloud and sends request to the service.
@protocol PRKAuthenticator <POSSchedulable>

/// Signal emits Cloud-specific credentials object if user is signed in or nil otherwise.
@property (atomic, readonly, nonnull) RACSignal *credentialsSignal;

/// @brief Starts user interaction to perform sign in procedure.
/// @return Signal, which emits:
///         * @YES if sign in process was succeed
///         * @NO sign in process was canceled
///         * NSError if sign in process failed.
- (nonnull RACSignal *)signInFromController:(nonnull UIViewController *)controller;

/// @brief Invalidates credentials.
- (void)signOut;

@end

#pragma mark -

/// Authentication errors.
@interface NSError (PRKAuthenticator)

/// @brief Factory method for signin errors.
/// @param cloudType Type of the cloud service.
/// @return Localized authentication error.
+ (nonnull NSError *)prk_authenticationErrorForCloud:(PRKCloudType)cloudType;

@end
