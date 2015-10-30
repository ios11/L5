//
//  PRKPresentationOrchestrator.m
//  PhotoPark
//
//  Created by Pavel Osipov on 02.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKPresentationOrchestrator.h"

// UI
#import "PRKAppDelegate.h"
#import "PRKAuthenticationViewController.h"
#import "PRKBaseNavigationController.h"
#import "PRKFeedViewController.h"
#import "PRKLaunchViewController.h"
#import "PRKLaunchErrorViewController.h"
#import <DropboxSDK/DropboxSDK.h>

// Services
#import "PRKAppAssembly.h"
#import "PRKAppMonitor.h"
#import "PRKAuthenticator.h"
#import "PRKEnvironment.h"
#import "PRKTracker.h"

@interface PRKPresentationOrchestrator ()
@property (nonatomic) PRKAppAssembly *assembly;
@property (nonatomic, weak) PRKAppDelegate *appDelegate;
@property (nonatomic) UIViewController *rootViewController;
@end

@implementation PRKPresentationOrchestrator
@dynamic rootViewController;

- (void)launchWithAppDelegate:(PRKAppDelegate *)appDelegate {
    POSRX_CHECK(appDelegate);
    self.appDelegate = appDelegate;
    self.rootViewController = [PRKLaunchViewController new];
    [[PRKAppAssembly assemblyWithAppMonitor:appDelegate] subscribeNext:^(PRKAppAssembly *assembly) {
        self.assembly = assembly;
    } error:^(NSError *error) {
        self.rootViewController = [[PRKLaunchErrorViewController alloc] initWithError:error];
    } completed:^{
        [self p_trackLaunch];
        [self p_setupBindings];
    }];
}

- (UIViewController *)rootViewController {
    return _appDelegate.window.rootViewController;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (!_appDelegate.window) {
        _appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _appDelegate.window.rootViewController = rootViewController;
        _appDelegate.window.backgroundColor = [UIColor whiteColor];
        [_appDelegate.window makeKeyAndVisible];
    } else {
        _appDelegate.window.rootViewController = rootViewController;
    }
}

- (void)p_setupBindings {
    @weakify(self)
    [_assembly.UI.authenticator.credentialsSignal subscribeNext:^(id credentials) {
        @strongify(self);
        if (![credentials accessToken]) {
            self.rootViewController = [[PRKAuthenticationViewController alloc] initWithAssembly:_assembly];
        } else {
            PRKFeedViewController *feedViewController = [[PRKFeedViewController alloc] initWithAssembly:_assembly];
            PRKBaseNavigationController *navigationController = [[PRKBaseNavigationController alloc]
                                                                 initWithRootViewController:feedViewController
                                                                 assembly:_assembly];
            self.rootViewController = navigationController;
        }
    }];
}

- (void)p_trackLaunch {
    [_assembly.TS.tracker trackEventWithType:PRKTrackerEventTypeUX action:@"launch"];
}

@end
