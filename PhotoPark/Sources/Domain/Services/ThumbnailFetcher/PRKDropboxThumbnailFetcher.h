//
//  PRKDropboxThumbnailFetcher.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKThumbnailFetcher.h"

@protocol PRKHost;

@interface PRKDropboxThumbnailFetcher : POSSchedulableObject <PRKThumbnailFetcher>

/// @brief The only available initializer.
/// @param host Mandatory host of the Dropbox API service.
/// @return NodeFetcher instance which will be scheduled in the same scheduler as host.
- (nonnull instancetype)initWithHost:(nonnull id<PRKHost>)host;

@end
