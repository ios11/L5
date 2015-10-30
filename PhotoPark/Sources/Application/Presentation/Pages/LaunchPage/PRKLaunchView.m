//
//  PRKLaunchView.m
//  PhotoPark
//
//  Created by Pavel Osipov on 26.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKLaunchView.h"

@interface PRKLaunchView ()
@property (nonatomic, weak) UIActivityIndicatorView *loadingIndicator;
@end

@implementation PRKLaunchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _loadingIndicator = [self p_addLoadingIndicator];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark Private

- (UIActivityIndicatorView *)p_addLoadingIndicator {
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc]
                                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    view.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    view.color = [UIColor whiteColor];
    [view startAnimating];
    [self addSubview:view];
    return view;
}

@end
