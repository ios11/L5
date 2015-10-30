//
//  PRKAuthorizationViewController.m
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAuthenticationViewController.h"
#import "PRKAuthenticationView.h"
#import "PRKAppAssembly.h"
#import "PRKCloudTypes.h"
#import "PRKAuthenticator.h"

@interface PRKAuthenticationViewController ()
@property (nonatomic, readonly, weak) PRKAppAssembly *assembly;
@end

@implementation PRKAuthenticationViewController

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithAssembly:(PRKAppAssembly *)assembly {
    POSRX_CHECK(assembly);
    if (self = [super init]) {
        _assembly = assembly;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    PRKAuthenticationView *rootView = [[PRKAuthenticationView alloc] initWithFrame:CGRectZero];
    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self.assembly.UI.authenticator signInFromController:self];
    }];
    rootView.dropboxButton.rac_command = loginCommand;
    self.view = rootView;
}

@end
