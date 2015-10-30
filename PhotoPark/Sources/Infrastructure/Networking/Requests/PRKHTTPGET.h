//
//  PRKHTTPGET.h
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "POSHTTPRequest+PRK.h"

/// Group of factory methods to create HTTP GET requests.
@interface PRKHTTPGET : NSObject

+ (POSHTTPRequest *)path:(NSString *)path
                   query:(NSDictionary *)query
             dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler;

+ (POSHTTPRequest *)path:(NSString *)path
             dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler;

+ (POSHTTPRequest *)query:(NSDictionary *)query;

+ (POSHTTPRequest *)dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler;

@end
