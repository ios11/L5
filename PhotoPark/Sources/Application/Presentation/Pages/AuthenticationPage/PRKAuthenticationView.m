//
//  PRKAuthenticationView.m
//  PhotoPark
//
//  Created by Pavel Osipov on 14.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAuthenticationView.h"
#import <Classy/Classy.h>
#import <Masonry/Masonry.h>

@interface PRKAuthenticationView ()

@property (nonatomic, weak) UIButton *dropboxButton;

@end

@implementation PRKAuthenticationView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dropboxButton = [self p_addDropboxButton];
    }
    return self;
}

#pragma mark - Layout Elements

- (UIButton *)p_addDropboxButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.cas_styleClass = @"login";
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(40, 40, 40, 40));
    }];
    return button;
}

@end
