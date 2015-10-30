//
//  PRKDropboxHost.h
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKTrackableHost.h"

@protocol PRKAuthenticator;

/// Implmentation of the PRKHost protocol for communication with Dropbox API service.
@interface PRKDropboxHost : PRKTrackableHost

/// @brief The only available designated initializer.
/// @param gateway Mandatory gateway.
/// @param URL Mandatory base URL of Dropbox host.
/// @param tracker Mandatory tracker.
/// @param authenticator Mandatory Host label which will be assigned to all its errors.
/// @return Host instance.
- (instancetype)initWithGateway:(id<POSHTTPGateway>)gateway
                            URL:(NSURL *)URL
                        tracker:(id<PRKTracker>)tracker
                  authenticator:(id<PRKAuthenticator>)authenticator;

@end
