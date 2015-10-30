//
//  PRKDropboxNodeFetcher.h
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKNodeFecher.h"

@protocol PRKHost;

@interface PRKDropboxNodeFetcher : POSSchedulableObject <PRKNodeFetcher>

/// @brief The only available initializer.
/// @param host Mandatory host of the Dropbox API service.
/// @return NodeFetcher instance which will be scheduled in the same scheduler as host.
- (nonnull instancetype)initWithHost:(nonnull id<PRKHost>)host;

@end
