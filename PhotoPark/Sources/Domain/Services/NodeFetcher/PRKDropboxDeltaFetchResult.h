//
//  PRKDropboxDeltaFetchResult.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import <POSJSONParsing/POSJSONParsing.h>

@interface PRKDropboxDeltaFetchResult : NSObject

@property (nonatomic, readonly) BOOL hasMore;
@property (nonatomic, readonly, nonnull) NSString *cursor;
@property (nonatomic, readonly, nonnull) NSArray *nodes;

+ (nonnull instancetype)parseDeltaResponseData:(nonnull NSData *)responseData;

@end
