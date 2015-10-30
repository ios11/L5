//
//  PRKHTTPGET.m
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKHTTPGET.h"
#import <POSRx/NSDictionary+POSRx.h>

@implementation PRKHTTPGET

+ (POSHTTPRequest *)path:(NSString *)path dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler {
    POSRX_CHECK(path);
    POSRX_CHECK(dataHandler);
    return [self path:path query:nil dataHandler:dataHandler];
}

+ (POSHTTPRequest *)query:(NSDictionary *)query {
    POSRX_CHECK(query);
    return [self path:nil query:query dataHandler:nil];
}

+ (POSHTTPRequest *)dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler {
    POSRX_CHECK(dataHandler);
    return [self path:nil query:nil dataHandler:dataHandler];
}

+ (POSHTTPRequest *)path:(NSString *)path
                   query:(NSDictionary *)query
             dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler {
    POSHTTPRequest *request = [[POSHTTPRequest alloc]
                               initWithType:POSHTTPRequestTypeGET
                               method:[POSHTTPRequestMethod path:path query:query]
                               body:nil
                               headerFields:nil];
    request.prk_responseDataHandler = dataHandler;
    return request;
}

@end
