//
//  PRKUserDefaultsKeyedStoreBackend.h
//  PhotoPark
//
//  Created by Pavel Osipov on 23.09.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKKeyedStoreBackend.h"

@interface PRKUserDefaultsKeyedStoreBackend : NSObject <PRKKeyedStoreBackend>

/// @brief The only designated initializer.
/// @param userDefaults Mandatory UserDefaults instance.
/// @param dataKey Mandatory key specified place for data persisting.
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
                             dataKey:(NSString *)dataKey;

@end
