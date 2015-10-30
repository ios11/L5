//
//  PRKTrackableHost.h
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKHost.h"

@protocol PRKTracker;

/// Implmentation of the PRKHost protocol, which tracks
/// all network and server errors to the PRKTracker.
@interface PRKTrackableHost : PRKHost

/// @brief The only available designated initializer.
/// @param gateway Mandatory gateway.
/// @param URL Mandatory URL.
/// @param tracker Mandatory tracker.
/// @param hostLabel Mandatory Host label which will be assigned to all its errors.
/// @return Host instance.
- (instancetype)initWithGateway:(id<POSHTTPGateway>)gateway
                            URL:(NSURL *)URL
                        tracker:(id<PRKTracker>)tracker
                      hostLabel:(NSString *)hostLabel;

@end
