//
//  PRKLaunchViewController.m
//  PhotoPark
//
//  Created by Pavel Osipov on 26.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKLaunchViewController.h"
#import "PRKLaunchView.h"

@implementation PRKLaunchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PRKLaunchView *launchView = [[PRKLaunchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:launchView];
}

#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return ![self isViewLoaded];
}

@end
