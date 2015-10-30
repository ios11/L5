//
//  PRKMediaInfo.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface PRKMediaInfo : NSObject

@property (nonatomic, readonly, nonnull) NSDate *timeTaken;
@property (nonatomic, readonly, nullable) CLLocation *location;

- (nonnull instancetype)initWithTimeTaken:(nonnull NSDate *)timeTaken
                                 location:(nullable CLLocation *)location;

@end
