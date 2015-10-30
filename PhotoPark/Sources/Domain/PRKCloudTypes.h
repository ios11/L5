//
//  PRKCloudTypes.h
//  PhotoPark
//
//  Created by Pavel Osipov on 16.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, PRKCloudType) {
    PRKCloudTypeDropbox = 11
};

NS_INLINE NSString *PRKStringFromCloudType(PRKCloudType type) {
    switch (type) {
        case PRKCloudTypeDropbox: return @"Dropbox";
    }
}
