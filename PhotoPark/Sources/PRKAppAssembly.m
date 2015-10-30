//
//  PRKAppAssembly.m
//  PhotoPark
//
//  Created by Pavel Osipov on 14.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAppAssembly.h"
#import "PRKDropboxAuthenticator.h"
#import "PRKDropboxHost.h"
#import "PRKDropboxNodeFetcher.h"
#import "PRKDropboxThumbnailFetcher.h"
#import "PRKTrackableAuthenticator.h"
#import "PRKEnvironment.h"
#import "PRKKeyedStore.h"
#import "PRKKeychainKeyedStoreBackend.h"
#import "PRKTracker.h"
#import "NSBundle+PRKPresentation.h"

@interface PRKTSAssembly ()
@property (nonatomic) id<PRKAppMonitor> appMonitor;
@property (nonatomic) id<PRKEnvironment> environment;
@property (nonatomic) id<PRKKeyedStore> secureStore;
@property (nonatomic) id<PRKTracker> tracker;
@end

@implementation PRKTSAssembly

- (RACSignal *)setupWithAssembly:(PRKAppAssembly *)assmebly appMonitor:(id<PRKAppMonitor>)appMonitor {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.appMonitor = appMonitor;
        self.environment = [[PRKEnvironment alloc] initWithBundle:[NSBundle mainBundle]];
        NSError *error = nil;
        self.secureStore = [[PRKKeyedStore alloc]
                            initWithBackend:[[PRKKeychainKeyedStoreBackend alloc]
                                             initWithDataKey:@"store"
                                             service:@"com.photisfy"]
                            error:&error];
        self.tracker = [[PRKTracker alloc] initWithStore:_secureStore environment:_environment];
        if (error) {
            [_tracker trackError:error action:@"secure_keychain_initialization"];
        }
        [subscriber sendCompleted];
        return nil;
    }];
}

@end

#pragma mark -

@interface PRKUIAssembly ()
@property (nonatomic) RACScheduler *scheduler;
@property (nonatomic) id<PRKAuthenticator> authenticator;
@end

@implementation PRKUIAssembly

- (instancetype)init {
    if (self = [super init]) {
        _scheduler = [RACScheduler mainThreadScheduler];
    }
    return self;
}

- (RACSignal *)setupWithAssembly:(PRKAppAssembly *)assmebly {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [_scheduler schedule:^{
            self.authenticator = [[PRKTrackableAuthenticator alloc]
                                  initWithTracker:assmebly.TS.tracker
                                  authenticator:[[PRKDropboxAuthenticator alloc]
                                                 initWithAppMonitor:assmebly.TS.appMonitor
                                                 dropboxAppKey:[[NSBundle mainBundle] prk_dropboxAppKey]
                                                 dropboxAppSecret:[[NSBundle mainBundle] prk_dropboxAppSecret]]
                                  forCloud:PRKCloudTypeDropbox];
            [subscriber sendCompleted];
        }];
    }];
}

@end

#pragma mark -

@interface PRKBLAssembly ()
@property (nonatomic) RACTargetQueueScheduler *scheduler;
@property (nonatomic) POSHTTPGateway *gateway;
@property (nonatomic) id<PRKNodeFetcher> nodeFetcher;
@property (nonatomic) id<PRKThumbnailFetcher> thumbnailFetcher;
@end

@implementation PRKBLAssembly

- (instancetype)init {
    if (self = [super init]) {
        _scheduler = (id)[RACScheduler schedulerWithPriority:RACSchedulerPriorityLow];
    }
    return self;
}

- (RACSignal *)setupWithAssembly:(PRKAppAssembly *)assmebly {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [_scheduler schedule:^{
            self.gateway = [[POSHTTPGateway alloc]
                            initWithScheduler:_scheduler
                            backgroundSessionIdentifier:@"com.photisfy.nsurlsessiond"];
            self.nodeFetcher = [[PRKDropboxNodeFetcher alloc]
                                initWithHost:[[PRKDropboxHost alloc]
                                              initWithGateway:self->_gateway
                                              URL:[NSURL URLWithString:@"https://api.dropboxapi.com/1"]
                                              tracker:assmebly.TS.tracker
                                              authenticator:assmebly.UI.authenticator]];
            self.thumbnailFetcher = [[PRKDropboxThumbnailFetcher alloc]
                                     initWithHost:[[PRKDropboxHost alloc]
                                                   initWithGateway:self->_gateway
                                                   URL:[NSURL URLWithString:@"https://content.dropboxapi.com/1/thumbnails/auto/"]
                                                   tracker:assmebly.TS.tracker
                                                   authenticator:assmebly.UI.authenticator]];
            [subscriber sendCompleted];
        }];
    }];
}

@end

#pragma mark -

@interface PRKAppAssembly ()
@end

@implementation PRKAppAssembly

- (instancetype)init {
    if (self = [super init]) {
        _TS = [PRKTSAssembly new];
        _BL = [PRKBLAssembly new];
        _UI = [PRKUIAssembly new];
    }
    return self;
}

+ (RACSignal *)assemblyWithAppMonitor:(id<PRKAppMonitor>)appMonitor {
    PRKAppAssembly *assembly = [PRKAppAssembly new];
    return [[assembly.TS setupWithAssembly:assembly appMonitor:appMonitor] then:^RACSignal *{
        return [[[assembly.UI setupWithAssembly:assembly] then:^RACSignal *{
            return [[assembly.BL setupWithAssembly:assembly] deliverOnMainThread];
        }] then:^RACSignal *{
            return [RACSignal return:assembly];
        }];
    }];
}

@end
