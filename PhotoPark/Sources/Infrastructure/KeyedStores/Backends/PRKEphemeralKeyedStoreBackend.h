//
//  PRKEphemeralKeyedStoreBackend.h
//  PhotoPark
//
//  Created by Pavel Osipov on 26.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKKeyedStoreBackend.h"

/// Keyed store, which stores all its data in the RAM.
@interface PRKEphemeralKeyedStoreBackend : NSObject <PRKKeyedStoreBackend>

@end
