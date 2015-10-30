//
//  PRKAppAssembly.h
//  PhotoPark
//
//  Created by Pavel Osipov on 14.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <POSRx/POSRx.h>

@protocol PRKAppMonitor;
@protocol PRKAuthenticator;
@protocol PRKNodeFetcher;
@protocol PRKThumbnailFetcher;
@protocol PRKTracker;

/// Group of thread-safe services, which can be used within any thread.
@interface PRKTSAssembly : NSObject
@property (nonatomic, readonly) id<PRKTracker> tracker;
@end

/// Group of services, scheduled within main thread.
@interface PRKUIAssembly : NSObject
@property (nonatomic, readonly) id<PRKAuthenticator> authenticator;
@end

/// Group of services, scheduled within business logic worker thread.
@interface PRKBLAssembly : NSObject
@property (nonatomic, readonly) id<PRKNodeFetcher> nodeFetcher;
@property (nonatomic, readonly) id<PRKThumbnailFetcher> thumbnailFetcher;
@end

/// All application services.
@interface PRKAppAssembly : NSObject

@property (nonatomic, readonly) PRKTSAssembly *TS;
@property (nonatomic, readonly) PRKBLAssembly *BL;
@property (nonatomic, readonly) PRKUIAssembly *UI;

/// The only method which asynchronously will prepare assembly for usage.
+ (RACSignal *)assemblyWithAppMonitor:(id<PRKAppMonitor>)appMonitor;

@end

