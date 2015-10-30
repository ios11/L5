//
//  PRKDropboxNodeFetcher.m
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKDropboxNodeFetcher.h"
#import "PRKDropboxDeltaFetchResult.h"
#import "PRKHost.h"
#import "PRKHTTPPOST.h"

@interface PRKDropboxNodeFetcher ()
@property (nonatomic, readonly) id<PRKHost> host;
@end

@implementation PRKDropboxNodeFetcher

POSRX_DEADLYFY_SCHEDULABLE_INITIALIZERS

- (instancetype)initWithHost:(id<PRKHost>)host {
    POSRX_CHECK(host);
    if (self = [super initWithScheduler:host.scheduler]) {
        _host = host;
    }
    return self;
}

#pragma mark PRKNodeFetcher

- (RACSignal *)fetchNodes {
    return [_host pushRequest:
            [PRKHTTPPOST
             path:@"/delta"
             parameters:@{@"path_prefix": @"/Camera Uploads",
                          @"include_media_info": @"true"}
             dataHandler:^id(NSData *responseData, NSError **error) {
                 NSString *allValues = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                 NSLog(@"%@", allValues);
                 PRKDropboxDeltaFetchResult *fetchResult = [PRKDropboxDeltaFetchResult
                                                            parseDeltaResponseData:responseData];
                 return fetchResult.nodes;
             }]];
}

@end
