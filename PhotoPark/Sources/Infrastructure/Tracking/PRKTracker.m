//
//  PRKTracker.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKTracker.h"
#import "PRKEnvironment.h"
#import "PRKKeyedStore.h"
#import "NSError+PRKInfrastructure.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <POSRx/POSRx.h>

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

static NSString *PRKGenerateUUID();
static NSString *PRKStringFromTrackerEventType(PRKTrackerEventType type);

@interface PRKTracker ()
@property (nonatomic) NSString *appID;
@property (nonatomic, readonly) NSString *sessionID;
@property (nonatomic, readonly, weak) id<PRKEnvironment> environment;
@property (nonatomic, readonly, weak) id<PRKKeyedStore> persistentStore;
@end

@implementation PRKTracker

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithStore:(id<PRKKeyedStore>)store
                  environment:(id<PRKEnvironment>)environment {
    POSRX_CHECK(store);
    POSRX_CHECK(environment);
    if (self = [super init]) {
        _sessionID = PRKGenerateUUID();
        _environment = environment;
        _persistentStore = store;
        [self p_setupLoggers];
        [self p_setupAppID];
    }
    return self;
}

#pragma mark - Public

- (void)trackEventWithType:(PRKTrackerEventType)type action:(NSString *)action {
    [self trackEventWithType:type action:action label:nil value:nil params:nil];
}

- (void)trackEventWithType:(PRKTrackerEventType)type
                    action:(NSString *)action
                     label:(NSString *)label
                     value:(NSNumber *)value
                    params:(NSDictionary *)params {
    POSRX_CHECK(action);
    NSMutableDictionary *optionalParams = [NSMutableDictionary new];
    if (label) {
        optionalParams[@"action.label"] = label;
    }
    if (value) {
        optionalParams[@"action.value"] = [value stringValue];
    }
    if (params) {
        [optionalParams setValuesForKeysWithDictionary:params];
    }
    NSMutableString *paramsString = [NSMutableString new];
    [optionalParams enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [paramsString appendFormat:@" %@=\"%@\"", key, value];
    }];
    DDLogInfo(@"action.type=\"%@\" action.name=\"%@\"%@", PRKStringFromTrackerEventType(type), action, paramsString);
}

- (void)trackTimingWithType:(PRKTrackerEventType)type
               timeInterval:(NSTimeInterval)interval
                       name:(NSString *)name
                      label:(NSString *)label {
    POSRX_CHECK(name);
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    formatter.minimumFractionDigits = 3;
    formatter.maximumFractionDigits = 3;
    if (label) {
        params[@"action.label"] = label;
    }
    params[@"time"] = [formatter stringFromNumber:@(interval)];
    NSMutableString *paramsString = [NSMutableString new];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [paramsString appendFormat:@" %@=\"%@\"", key, value];
    }];
    DDLogInfo(@"action.type=\"%@\" action.name=\"%@\"%@", PRKStringFromTrackerEventType(type), name, paramsString);
}

- (void)trackError:(NSError *)error
            action:(NSString *)action {
    POSRX_CHECK(error);
    DDLogError(@"action.type=\"ERR\" action.name=\"%@\" error.id=\"%@\" error.desc=\"%@\"", action, error.prk_ID, error);
}

#pragma mark - Setup

- (void)p_setupAppID {
    static NSString *kAppIDKey = @"net.pavelosipov.AppIDKey";
    NSString *appID = [_persistentStore objectForKey:kAppIDKey];
    if (!appID) {
        self.appID = appID;
    } else {
        appID = PRKGenerateUUID();
        NSError *error = nil;
        [_persistentStore setObject:appID forKey:kAppIDKey error:&error];
        self.appID = appID;
        if (!error) {
            [self trackEventWithType:PRKTrackerEventTypeUX
                              action:@"new_user"];
        } else {
            [self trackError:error action:@"new_user_setup"];
        }
    }
}

- (void)p_setupLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end

#pragma mark - Utilities

NSString *PRKGenerateUUID() {
    CFUUIDRef UUID = CFUUIDCreate(NULL);
    NSString *UUIDString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, UUID);
    CFRelease(UUID);
    return UUIDString;
}

NSString *PRKStringFromTrackerEventType(PRKTrackerEventType type) {
    switch (type) {
        case PRKTrackerEventTypeUX:          return @"UXR";
        case PRKTrackerEventTypeUXModify:    return @"UXW";
        case PRKTrackerEventTypeCloud:       return @"CLR";
        case PRKTrackerEventTypeCloudModify: return @"CLW";
    }
}
