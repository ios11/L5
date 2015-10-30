//
//  PRKLaunchErrorViewController.m
//  PhotoPark
//
//  Created by Pavel Osipov on 26.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKLaunchErrorViewController.h"
#import "NSString+PRKInfrastructure.h"

@interface PRKLaunchErrorViewController ()
@property (nonatomic) NSError *error;
@end

@implementation PRKLaunchErrorViewController

- (instancetype)initWithError:(NSError *)error {
    if (self = [super init]) {
        _error = error;
    }
    return self;
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    [self p_setupMessageView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private

- (void)p_setupMessageView {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    messageLabel.backgroundColor = [UIColor blackColor];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = [@"LaunchFailureMessage" prk_localized];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.center = CGPointMake(self.view.bounds.size.width / 2.0,
                                      self.view.bounds.size.height / 2.0);
    [self.view addSubview:messageLabel];
}

@end
