//
//  PRKFileKeyedStoreBackend.h
//  PhotoPark
//
//  Created by Pavel Osipov on 13.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKKeyedStoreBackend.h"

@interface PRKFileKeyedStoreBackend : NSObject <PRKKeyedStoreBackend>

/// The only designated initializer.
- (instancetype)initWithFilePath:(NSString *)filePath;

@end