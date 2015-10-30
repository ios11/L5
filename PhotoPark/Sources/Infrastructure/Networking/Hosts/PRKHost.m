//
//  PRKHost.m
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKHost.h"
#import "POSHTTPRequest+PRK.h"
#import "NSError+PRKInfrastructure.h"

@interface PRKHost ()
@property (nonatomic) id<POSHTTPGateway> gateway;
@property (nonatomic) NSURL *URL;
@end

@implementation PRKHost

POSRX_DEADLYFY_SCHEDULABLE_INITIALIZERS

- (instancetype)initWithGateway:(id<POSHTTPGateway>)gateway URL:(NSURL *)URL {
    POSRX_CHECK(gateway);
    POSRX_CHECK(URL);
    if (self = [super initWithScheduler:gateway.scheduler]) {
        _gateway = gateway;
        _URL = URL;
    }
    return self;
}

- (RACSignal *)pushRequest:(POSHTTPRequest *)request {
    return [self pushRequest:request options:nil];
}

- (RACSignal *)pushRequest:(POSHTTPRequest *)request
                   options:(POSHTTPRequestExecutionOptions *)options {
    POSRX_CHECK(request);
    return [[[_gateway pushRequest:request toHost:self.URL options:options]
            catch:^RACSignal *(NSError *error) {
                return [RACSignal error:[NSError prk_networkErrorWithReason:error]];
            }] flattenMap:^RACSignal *(POSHTTPResponse *response) {
                @try {
                    NSError *error;
                    id parsedResponse = request.prk_responseHandler(response, &error);
                    if (error) {
                        return [RACSignal error:error];
                    }
                    if (parsedResponse) {
                        return [RACSignal return:parsedResponse];
                    }
                    return [RACSignal empty];
                } @catch (NSException *exception) {
                    NSParameterAssert(response.metadata.URL);
                    NSURL *issuedURL = response.metadata.URL ?: self.URL;
                    return [RACSignal error:[NSError prk_serverErrorWithURL:issuedURL
                                                                     format:exception.reason]];
                }
            }];
}

@end
