//
//  PRKThumbnailFetcher.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import <POSRx/POSRx.h>

@class PRKMediaNode;

/// Fetches thumbnails for nodes from the cloud service.
@protocol PRKThumbnailFetcher <POSSchedulable>

/// @return RACSignal which emits UIImage.
- (nonnull RACSignal *)fetchThumbnailForNode:(nonnull PRKMediaNode *)node;

@end
