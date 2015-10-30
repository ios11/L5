//
//  PRKAppDelegate.m
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAppDelegate.h"
#import "PRKPresentationOrchestrator.h"

@interface PRKAppDelegate ()
@property (nonatomic) RACSubject *openingURLSignal;
@property (nonatomic) PRKPresentationOrchestrator *orchestrator;
@end

@implementation PRKAppDelegate

- (instancetype)init {
    if (self = [super init]) {
        _openingURLSignal = [RACSubject subject];
        _orchestrator = [PRKPresentationOrchestrator new];
    }
    return self;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)options {
    [_orchestrator launchWithAppDelegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)sourceApp annotation:(id)annotation {
    [_openingURLSignal sendNext:RACTuplePack(app, url, sourceApp, annotation)];
    return YES;
}

@end
