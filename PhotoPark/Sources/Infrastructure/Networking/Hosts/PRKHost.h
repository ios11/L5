//
//  PRKHost.h
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <POSRx/POSRx.h>

/// Base host implementation.
@protocol PRKHost <POSSchedulable>

/// URL of the host. May be nil.
@property (nonatomic, readonly) NSURL *URL;

/// @brief Sends request to specified host.
/// @param request Mandatory request which will be send to host with specified baseURL.
/// @return Signal which emits response handling result.
- (RACSignal *)pushRequest:(POSHTTPRequest *)request;

/// @brief Sends request to specified host.
/// @param request Mandatory request which will be send to host with specified baseURL.
/// @param options Optional options.
/// @return Signal which emits response handling result.
- (RACSignal *)pushRequest:(POSHTTPRequest *)request
                   options:(POSHTTPRequestExecutionOptions *)options;

@end

/// Base implementation for PRKHost protocol.
@interface PRKHost : POSSchedulableObject <PRKHost>

/// @brief The designated initializer.
/// @param gateway Mandatory gateway.
/// @param URL Mandatory URL.
/// @return Host instance with static URL.
- (instancetype)initWithGateway:(id<POSHTTPGateway>)gateway URL:(NSURL *)URL;

@end
