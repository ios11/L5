//
//  PRKDropboxAuthenticator.m
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKDropboxAuthenticator.h"
#import "PRKAppMonitor.h"
#import <DropboxSDK/DropboxSDK.h>

@interface PRKDropboxAuthenticator () <DBSessionDelegate>
@property (nonatomic, readonly, weak) id<PRKAppMonitor> appMonitor;
@property (nonatomic, readonly) DBSession *session;
@property (nonatomic) RACSubject *credentialsSubject;
@property (atomic) RACSignal *credentialsSignal;
@end

@implementation PRKDropboxAuthenticator

#pragma mark Lifecycle

POSRX_DEADLYFY_SCHEDULABLE_INITIALIZERS

- (instancetype)initWithAppMonitor:(id<PRKAppMonitor>)appMonitor
                     dropboxAppKey:(NSString *)dropboxAppKey
                  dropboxAppSecret:(NSString *)dropboxAppSecret {
    POSRX_CHECK(appMonitor);
    POSRX_CHECK(dropboxAppKey);
    POSRX_CHECK(dropboxAppSecret);
    if (self = [super initWithScheduler:[RACTargetQueueScheduler pos_mainThreadScheduler]]) {
        _appMonitor = appMonitor;
        _credentialsSubject = [RACSubject subject];
        _credentialsSignal = [_credentialsSubject replayLast];
        _session = [self p_setupDropboxSessionWitAppKey:dropboxAppKey appSecret:dropboxAppSecret];
        [_credentialsSubject sendNext:[self p_userCredentials]];
    }
    return self;
}

#pragma mark PRKAuthenticator

- (RACSignal *)signInFromController:(UIViewController *)controller {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable *disposable = [self.appMonitor.openingURLSignal subscribeNext:^(RACTuple *args) {
            if (![self->_session handleOpenURL:args.second]) {
                [subscriber sendError:[NSError prk_authenticationErrorForCloud:PRKCloudTypeDropbox]];
            } else {
                if ([self->_session isLinked]) {
                    [self->_credentialsSubject sendNext:[self p_userCredentials]];
                }
                [subscriber sendNext:@([self->_session isLinked])];
                [subscriber sendCompleted];
            }
        }];
        [[DBSession sharedSession] linkFromController:controller];
        return disposable;
    }];
}

- (void)signOut {
    [[DBSession sharedSession] unlinkAll];
    [_credentialsSubject sendNext:nil];
}

#pragma mark - DBSessionDelegate

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId {
    [[DBSession sharedSession] unlinkAll];
    NSParameterAssert(![self p_userCredentials]);
    [_credentialsSubject sendNext:nil];
}

#pragma mark - Private

- (MPOAuthCredentialConcreteStore *)p_userCredentials {
    return [_session credentialStoreForUserId:_session.userIds.firstObject];
}

- (DBSession *)p_setupDropboxSessionWitAppKey:(NSString *)appKey
                                    appSecret:(NSString *)appSecret {
    DBSession *session = [[DBSession alloc]
        initWithAppKey:appKey
        appSecret:appSecret
        root:kDBRootDropbox];
    session.delegate = self;
    [DBSession setSharedSession:session];
    return session;
}

@end
