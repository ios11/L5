//
//  PRKUserDefaultsKeyValueStoreBackend.m
//  PhotoPark
//
//  Created by Pavel Osipov on 23.09.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKUserDefaultsKeyedStoreBackend.h"
#import "NSError+PRKInfrastructure.h"
#import <POSRx/POSRx.h>

@interface PRKUserDefaultsKeyedStoreBackend ()
@property (nonatomic, readonly) NSUserDefaults *store;
@property (nonatomic, readonly) NSString *dataKey;
@end

@implementation PRKUserDefaultsKeyedStoreBackend

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
                             dataKey:(NSString *)dataKey {
    POSRX_CHECK(userDefaults);
    POSRX_CHECK(dataKey);
    if (self = [super init]) {
        _store = userDefaults;
        _dataKey = [dataKey copy];
    }
    return self;
}

#pragma mark PRKKeyedStoreBackend

- (BOOL)saveData:(NSData *)data error:(NSError **)error {
    POSRX_CHECK(data);
    [_store setObject:data forKey:_dataKey];
    if (![_store synchronize]) {
        PRKAssignError(error, [NSError prk_systemErrorWithFormat:@"Failed to synchronize NSUserDefaults."]);
        return NO;
    }
    return YES;
}

- (NSData *)loadData:(NSError **)error {
    id data = [_store objectForKey:_dataKey];
    if (!data) {
        return nil;
    }
    if (![data isKindOfClass:NSData.class]) {
        PRKAssignError(error, [NSError prk_internalErrorWithFormat:
                               @"Unexpected object at key '%@' in NSUserDefaults: %@",
                               _dataKey, data]);
        return nil;
    }
    return data;
}

- (BOOL)removeData:(NSError **)error {
    [_store removeObjectForKey:_dataKey];
    [_store synchronize];
    return YES;
}

@end
