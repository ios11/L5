//
//  PRKDropboxThumbnailFetcher.m
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKDropboxThumbnailFetcher.h"
#import "PRKMediaNode.h"
#import "PRKHost.h"
#import "PRKHTTPGET.h"

NS_INLINE NSString *POSCreateStringByAddingPercentEscapes(NSString *unescaped, NSString *escapedSymbols) {
    return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(
        kCFAllocatorDefault,
        (CFStringRef)unescaped,
        NULL,
        (CFStringRef)escapedSymbols,
        kCFStringEncodingUTF8);
}


@interface PRKDropboxThumbnailFetcher ()
@property (nonatomic, readonly) id<PRKHost> host;
@end

@implementation PRKDropboxThumbnailFetcher

POSRX_DEADLYFY_SCHEDULABLE_INITIALIZERS

- (instancetype)initWithHost:(id<PRKHost>)host {
    POSRX_CHECK(host);
    if (self = [super initWithScheduler:host.scheduler]) {
        _host = host;
    }
    return self;
}

#pragma mark PRKThumbnailFetcher

- (nonnull RACSignal *)fetchThumbnailForNode:(nonnull PRKMediaNode *)node {
    POSRX_CHECK(node);
    return [_host pushRequest:
            [PRKHTTPGET
             path:POSCreateStringByAddingPercentEscapes(node.path, @"!*'();:@&=+$,/?%#[]")
             query:@{@"size": @"m"}
             dataHandler:^id(NSData *responseData, NSError **error) {
                 return [UIImage imageWithData:responseData];
             }]];
}

@end
