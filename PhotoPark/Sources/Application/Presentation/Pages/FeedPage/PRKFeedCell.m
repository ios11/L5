//
//  PRKFeedCell.m
//  PhotoPark
//
//  Created by Pavel Osipov on 02.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKFeedCell.h"

@interface PRKFeedCell ()
@end

@implementation PRKFeedCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:self.bounds];
        thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        thumbnailView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:thumbnailView];
        _thumbnailView = thumbnailView;
        self.clipsToBounds = YES;
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    }
    return self;
}

@end
