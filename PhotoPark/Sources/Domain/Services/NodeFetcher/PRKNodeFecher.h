//
//  PRKNodeFecher.h
//  PhotoPark
//
//  Created by Pavel Osipov on 12.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "POSSchedulableObject.h"

/// Fetches nodes from the cloud service.
@protocol PRKNodeFetcher <POSSchedulable>

/// @brief Fetches nodes.
/// @return Signal, which emits root node with all subnodes.
- (nonnull RACSignal *)fetchNodes;

@end
