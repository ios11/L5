//
//  PRKMediaNode.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKMediaInfo.h"

@interface PRKMediaNode : NSObject

@property (nonatomic, readonly, nonnull) NSString *path;
@property (nonatomic, readonly, nonnull) PRKMediaInfo *mediaInfo;
@property (nonatomic, readonly) BOOL thumbnailExists;

- (nonnull instancetype)initWithPath:(nonnull NSString *)path
                           mediaInfo:(nonnull PRKMediaInfo *)mediaInfo
                     thumbnailExists:(BOOL)thumbnailExists;

@end
