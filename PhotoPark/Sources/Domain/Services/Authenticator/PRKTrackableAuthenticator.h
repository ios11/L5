//
//  PRKTrackableAuthenticator.h
//  PhotoPark
//
//  Created by Pavel Osipov on 12.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAuthenticator.h"

@protocol PRKTracker;

@interface PRKTrackableAuthenticator : POSSchedulableObject <PRKAuthenticator>

/// The only designated initializer.
- (nonnull instancetype)initWithTracker:(nonnull id<PRKTracker>)tracker
                          authenticator:(nonnull id<PRKAuthenticator>)authenticator
                               forCloud:(PRKCloudType)cloudType;

@end
