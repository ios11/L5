//
//  PRKDropboxDeltaFetchResult.m
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKDropboxDeltaFetchResult.h"
#import "PRKMediaNode.h"
#import <POSRx/POSRx.h>

@interface NSDateFormatter (PRKDropboxDeltaFetchResult)
@end

@implementation NSDateFormatter (PRKDropboxDeltaFetchResult)

+ (NSDateFormatter *)prk_dropboxDateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"EEE, dd MMM YYYY HH:mm:ss ZZZ"]; // "Sat, 21 Aug 2010 22:31:20 +0000"
    });
    return dateFormatter;
}

@end

@interface PRKDropboxDeltaFetchResult ()
@property (nonatomic) BOOL hasMore;
@property (nonatomic, nonnull) NSString *cursor;
@property (nonatomic, nonnull) NSArray *nodes;
@end

@implementation PRKDropboxDeltaFetchResult

+ (nonnull instancetype)parseDeltaResponseData:(nonnull NSData *)responseData {
    POSRX_CHECK(responseData);
    POSJSONMap *deltaJSON = [[POSJSONMap alloc] initWithData:responseData];
    PRKDropboxDeltaFetchResult *fetchResult = [PRKDropboxDeltaFetchResult new];
    NSMutableArray *nodes = [NSMutableArray new];
    fetchResult.nodes = nodes;
    fetchResult.hasMore = [[[deltaJSON extract:@"has_more"] asNumber] boolValue];
    fetchResult.cursor = [[deltaJSON extract:@"cursor"] asString];
    NSArray *entries = [[deltaJSON extract:@"entries"] asArray];
    for (POSJSONObject *entry in entries) {
        NSArray *entryElements = [entry asArray];
        POSRX_CHECK(entryElements.count >= 2);
        POSJSONMap *nodeJSON = [entryElements[1] asMap];
        BOOL nodeIsDirectory = [[[nodeJSON extract:@"is_dir"] asNumber] boolValue];
        if (nodeIsDirectory) {
            continue;
        }
        POSJSONMap *mediaInfoJSON = [[nodeJSON tryExtract:@"photo_info"] asMap];
        if (!mediaInfoJSON) {
            mediaInfoJSON = [[nodeJSON tryExtract:@"video_info"] asMap];
            if (!mediaInfoJSON) {
                continue;
            }
        }
        [nodes addObject:[self p_parseNode:nodeJSON withMediaInfo:mediaInfoJSON]];
    }
    return fetchResult;
}

+ (nonnull PRKMediaNode *)p_parseNode:(nonnull POSJSONMap *)nodeJSON
                        withMediaInfo:(nonnull POSJSONMap *)mediaInfoJSON {
    return [[PRKMediaNode alloc]
            initWithPath:[[nodeJSON extract:@"path"] asString]
            mediaInfo:[self p_parseMediaInfoJSON:mediaInfoJSON]
            thumbnailExists:[[[nodeJSON extract:@"thumb_exists"] asNumber] boolValue]];
}
         
+ (nonnull PRKMediaInfo *)p_parseMediaInfoJSON:(nonnull POSJSONMap *)mediaInfoJSON {
    NSString *dateString = [[mediaInfoJSON extract:@"time_taken"] asString];
    NSDate *timeTaken = [[NSDateFormatter prk_dropboxDateFormatter] dateFromString:dateString];
    POSRX_CHECK_EX(timeTaken, @"Failed to parse date '%@'", dateString);
    POSJSONObject *locationJSON = [mediaInfoJSON extract:@"lat_long"];
    CLLocation *location = nil;
    if (![locationJSON isNull]) {
        NSArray *locationElements = [locationJSON asArray];
        POSRX_CHECK_EX(locationElements.count == 2, @"Unexpected location: %@", locationElements);
        location = [[CLLocation alloc]
                    initWithLatitude:[[locationElements[0] asNumber] doubleValue]
                    longitude:[[locationElements[1] asNumber] doubleValue]];
    }
    return [[PRKMediaInfo alloc] initWithTimeTaken:timeTaken location:location];
}

@end
