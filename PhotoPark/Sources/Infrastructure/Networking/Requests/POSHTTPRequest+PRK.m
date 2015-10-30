//
//  POSHTTPRequest+PRK.m
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "POSHTTPRequest+PRK.h"
#import "NSError+PRKInfrastructure.h"
#import <objc/runtime.h>

#pragma mark - POSHTTPRequest (PRK)

static char kPRKHTTPRequestResponseHandlerKey;
static char kPRKHTTPRequestResponseDataHandlerKey;

@implementation POSHTTPRequest (PRK)

- (PRKHTTPRequestResponseHandler)prk_responseHandler {
    PRKHTTPRequestResponseHandler handler = objc_getAssociatedObject(self, &kPRKHTTPRequestResponseHandlerKey);
    if (handler) {
        return handler;
    }
    return [^id(POSHTTPResponse *response, NSError **error) {
        if (![response.metadata contains2XXStatusCode]) {
            PRKAssignError(error, [NSError prk_serverErrorWithURL:response.metadata.URL
                                                   HTTPStatusCode:response.metadata.statusCode]);
            return nil;
        }
        return self.prk_responseDataHandler(response.data, error);
    } copy];
}

- (void)prk_setResponseHandler:(PRKHTTPRequestResponseHandler)handler {
    objc_setAssociatedObject(self, &kPRKHTTPRequestResponseHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PRKHTTPRequestResponseDataHandler)prk_responseDataHandler {
    PRKHTTPRequestResponseDataHandler handler = objc_getAssociatedObject(self, &kPRKHTTPRequestResponseDataHandlerKey);
    if (handler) {
        return handler;
    }
    return [^id(NSData *responseData, NSError **error) {
        return responseData;
    } copy];
}

- (void)prk_setResponseDataHandler:(PRKHTTPRequestResponseDataHandler)handler {
    objc_setAssociatedObject(self, &kPRKHTTPRequestResponseDataHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark - NSHTTPURLResponse (PRK)

@implementation NSHTTPURLResponse (PRK)

- (BOOL)contains2XXStatusCode {
    return self.statusCode / 100 == 2;
}

@end
