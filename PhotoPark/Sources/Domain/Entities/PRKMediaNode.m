//
//  PRKMediaNode.m
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKMediaNode.h"
#import <POSRx/POSRx.h>

@interface PRKMediaNode ()
@end

@implementation PRKMediaNode

POSRX_DEADLY_INITIALIZER(init)

- (nonnull instancetype)initWithPath:(nonnull NSString *)path
                           mediaInfo:(nonnull PRKMediaInfo *)mediaInfo
                     thumbnailExists:(BOOL)thumbnailExists {
    POSRX_CHECK(path.length > 0);
    if (self = [super init]) {
        _path = [path copy];
        _mediaInfo = mediaInfo;
        _thumbnailExists = thumbnailExists;
    }
    return self;
}

@end
