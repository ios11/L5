//
//  PRKHTTPPOST.h
//  PhotoPark
//
//  Created by Pavel Osipov on 28.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "POSHTTPRequest+PRK.h"

@interface PRKHTTPPOST : NSObject

+ (POSHTTPRequest *)path:(NSString *)path
              parameters:(NSDictionary *)parameters
             dataHandler:(PRKHTTPRequestResponseDataHandler)dataHandler;

@end
