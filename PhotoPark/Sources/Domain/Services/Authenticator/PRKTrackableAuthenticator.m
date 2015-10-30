//
//  PRKTrackableAuthenticator.m
//  PhotoPark
//
//  Created by Pavel Osipov on 12.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKTrackableAuthenticator.h"
#import "PRKTracker.h"

@interface PRKTrackableAuthenticator ()
@property (nonatomic, readonly) id<PRKTracker> tracker;
@property (nonatomic, readonly) id<PRKAuthenticator> innerAuthenticator;
@property (nonatomic, readonly) PRKCloudType cloudType;
@property (nonatomic) RACDisposable *credentalsSubscription;
@end

@implementation PRKTrackableAuthenticator

POSRX_DEADLYFY_SCHEDULABLE_INITIALIZERS

- (instancetype)initWithTracker:(id<PRKTracker>)tracker
                  authenticator:(id<PRKAuthenticator>)authenticator
                       forCloud:(PRKCloudType)cloudType {
    POSRX_CHECK(tracker);
    POSRX_CHECK(authenticator);
    if (self = [super initWithScheduler:authenticator.scheduler]) {
        _tracker = tracker;
        _innerAuthenticator = authenticator;
        _cloudType = cloudType;
    }
    return self;
}

#pragma mark PRKAuthenticator

- (RACSignal *)credentialsSignal {
    return _innerAuthenticator.credentialsSignal;
}

- (RACSignal *)signInFromController:(UIViewController *)controller {
    return [[[_innerAuthenticator signInFromController:controller] doNext:^(NSNumber *result) {
        if (result.boolValue) {
            [self p_trackSignInResult:@"succeed"];
            @weakify(self);
            self.credentalsSubscription = [self->_innerAuthenticator.credentialsSignal subscribeNext:^(id credentials) {
                @strongify(self);
                if (!credentials) {
                    [self p_trackSignOutWithReason:@"cloud"];
                }
            }];
        } else {
            [self p_trackSignInResult:@"canceled"];
        }
    }] doError:^(NSError *error) {
        [self p_trackSignInResult:@"failed"];
        [self->_tracker trackError:error action:@"signin"];
    }];
}

- (void)signOut {
    [_credentalsSubscription dispose];
    [self p_trackSignOutWithReason:@"user"];
    [_innerAuthenticator signOut];
}

#pragma mark Private

- (void)p_trackSignInResult:(NSString *)result {
    [_tracker trackEventWithType:PRKTrackerEventTypeCloud
                          action:@"signin"
                           label:PRKStringFromCloudType(self->_cloudType)
                           value:nil
                          params:@{@"result": result}];
}

- (void)p_trackSignOutWithReason:(NSString *)reason {
    [_tracker trackEventWithType:PRKTrackerEventTypeCloud
                          action:@"signout"
                           label:PRKStringFromCloudType(self->_cloudType)
                           value:nil
                          params:@{@"reason": reason}];
}

@end
