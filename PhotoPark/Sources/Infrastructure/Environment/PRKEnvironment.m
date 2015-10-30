//
//  PRKEnvironment.m
//  PhotoPark
//
//  Created by Pavel Osipov on 30.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKEnvironment.h"
#import "UIDevice+PRKInfrastructure.h"
#import <POSRx/POSRx.h>

@interface PRKEnvironment ()
@property (nonatomic, readonly) NSBundle *bundle;
@end

@implementation PRKEnvironment

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithBundle:(NSBundle *)bundle {
    POSRX_CHECK(bundle);
    if (self = [super init]) {
        _bundle = bundle;
    }
    return self;
}

- (NSString *)fullVersion {
    NSString* version = _bundle.infoDictionary[@"CFBundleShortVersionString"];
    NSString* buildNumber = nil;
    buildNumber = PRKIsDebugMode() ? @"dev" : _bundle.infoDictionary[@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@.%@%@", version, buildNumber, [self.class p_versionSuffix]];
}

- (NSString *)userAgent {
    NSString *software = [NSString stringWithFormat:@"%@ %@",
                          [UIDevice currentDevice].systemName,
                          [UIDevice currentDevice].systemVersion];
    return [NSString stringWithFormat:@"%@/%@ (%@; %@)",
            _bundle.infoDictionary[@"CFBundleExecutable"],
            [self fullVersion],
            [UIDevice prk_platformName],
            software];
}

#pragma mark - Private

+ (NSString *)p_versionSuffix {
#if defined(ALPHA)
    return @" Alpha";
#elif defined(BETA)
    return @" Beta";
#else
    return @"";
#endif
}

@end

BOOL PRKIsDebugMode() {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}
