//
//  PRKTrackableHost.m
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKTrackableHost.h"
#import "PRKTracker.h"

@interface PRKTrackableHost ()
@property (nonatomic, readonly) id<PRKTracker> tracker;
@property (nonatomic, readonly) NSString *hostLabel;
@end

@implementation PRKTrackableHost

POSRX_DEADLY_INITIALIZER(initWithGateway:(id<POSHTTPGateway>)gateway URL:(NSURL *)URL)

- (instancetype)initWithGateway:(id<POSHTTPGateway>)gateway
                            URL:(NSURL *)URL
                        tracker:(id<PRKTracker>)tracker
                      hostLabel:(NSString *)hostLabel {
    POSRX_CHECK(tracker);
    POSRX_CHECK(hostLabel);
    if (self = [super initWithGateway:gateway URL:URL]) {
        _tracker = tracker;
        _hostLabel = [hostLabel copy];
    }
    return self;
}

- (RACSignal *)pushRequest:(POSHTTPRequest *)request
                   options:(POSHTTPRequestExecutionOptions *)options {
    return [[super pushRequest:request options:options] doError:^(NSError *error) {
        [self.tracker trackError:error action:_hostLabel];
    }];
}

@end
