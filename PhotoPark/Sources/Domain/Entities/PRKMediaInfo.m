//
//  PRKMediaInfo.m
//  PhotoPark
//
//  Created by Pavel Osipov on 29.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKMediaInfo.h"
#import <POSRx/POSRx.h>

@implementation PRKMediaInfo

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithTimeTaken:(NSDate *)timeTaken location:(CLLocation *)location {
    POSRX_CHECK(timeTaken);
    if (self = [super init]) {
        _timeTaken = timeTaken;
        _location = location;
    }
    return self;
}

@end
