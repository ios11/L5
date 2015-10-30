//
//  PRKAppMonitor.h
//  PhotoPark
//
//  Created by Pavel Osipov on 14.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

/// Thread-safe service.
@protocol PRKAppMonitor <NSObject>

/// Emits RACTuple in main thread with AppDelegate callback parametes when application is opened with some URL.
@property (nonatomic, readonly) RACSignal *openingURLSignal;

@end
