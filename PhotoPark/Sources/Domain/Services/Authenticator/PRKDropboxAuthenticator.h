//
//  PRKDropboxAuthenticator.h
//  PhotoPark
//
//  Created by Pavel Osipov on 08.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAuthenticator.h"

@protocol PRKAppMonitor;

/// Authenticates user in Dropbox service.
@interface PRKDropboxAuthenticator : POSSchedulableObject <PRKAuthenticator>

/// @brief The designated initializer.
/// @param appMonitor Mandatory appMonitor.
/// @return Object instance, which will be scheduled in main thread scheduler.
- (nonnull instancetype)initWithAppMonitor:(nonnull id<PRKAppMonitor>)appMonitor
                             dropboxAppKey:(nonnull NSString *)dropboxAppKey
                          dropboxAppSecret:(nonnull NSString *)dropboxAppSecret;

@end
