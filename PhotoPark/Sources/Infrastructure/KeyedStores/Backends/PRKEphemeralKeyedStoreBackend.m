//
//  PRKEphemeralKeyedStoreBackend.m
//  PhotoPark
//
//  Created by Pavel Osipov on 26.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKEphemeralKeyedStoreBackend.h"
#import <POSRx/POSRx.h>

@interface PRKEphemeralKeyedStoreBackend ()
@property (nonatomic) NSData *data;
@end

@implementation PRKEphemeralKeyedStoreBackend

#pragma mark PRKKeyedStoreBackend

- (BOOL)saveData:(NSData *)data error:(NSError **)error {
    POSRX_CHECK(data);
    self.data = [data copy];
    return YES;
}

- (NSData *)loadData:(NSError **)error {
    return [_data copy];
}

- (BOOL)removeData:(NSError **)error {
    self.data = nil;
    return YES;
}

@end
