//
//  PRKFileKeyedStoreBackend.m
//  PhotoPark
//
//  Created by Pavel Osipov on 13.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKFileKeyedStoreBackend.h"
#import "NSError+PRKInfrastructure.h"
#import <POSRx/POSRx.h>

@interface PRKFileKeyedStoreBackend ()
@property (nonatomic, readonly) NSString *filePath;
@end

@implementation PRKFileKeyedStoreBackend

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithFilePath:(NSString *)filePath {
    POSRX_CHECK(filePath);
    POSRX_CHECK([[NSURL URLWithString:filePath] isFileURL]);
    if (self = [super init]) {
        _filePath = [filePath copy];
    }
    return self;
}

#pragma mark PRKKeyedStoreBackend

- (BOOL)saveData:(NSData *)data error:(NSError **)error {
    POSRX_CHECK(data);
    NSError *cocoaError = nil;
    if (![data writeToFile:_filePath options:NSDataWritingAtomic error:&cocoaError]) {
        PRKAssignError(error, [NSError prk_systemErrorWithReason:cocoaError]);
        return NO;
    }
    return YES;
}

- (NSData *)loadData:(NSError **)error {
    NSError *cocoaError = nil;
    NSData *data = [NSData dataWithContentsOfFile:_filePath options:NSDataReadingMappedIfSafe error:&cocoaError];
    if (cocoaError) {
        PRKAssignError(error, [NSError prk_systemErrorWithReason:cocoaError]);
        return nil;
    }
    return data;
}

- (BOOL)removeData:(NSError **)error {
    NSError *cocoaError = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:_filePath error:&cocoaError]) {
        PRKAssignError(error, [NSError prk_systemErrorWithReason:cocoaError]);
        return NO;
    }
    return YES;
}

@end
