//
//  PRKHTTPPOST.m
//  PhotoPark
//
//  Created by Pavel Osipov on 28.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKHTTPPOST.h"

@implementation PRKHTTPPOST

+ (POSHTTPRequest *)path:(NSString *)path
              parameters:(NSDictionary *)parameters
             dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler {
    POSHTTPRequest *request = [[POSHTTPRequest alloc]
                               initWithType:POSHTTPRequestTypePOST
                               method:[POSHTTPRequestMethod path:path query:nil]
                               body:[parameters posrx_URLBody]
                               headerFields:nil];
    request.prk_responseDataHandler = dataHandler;
    return request;
}

@end
