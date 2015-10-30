//
//  PRKPresentationOrchestrator.h
//  PhotoPark
//
//  Created by Pavel Osipov on 02.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRKAppDelegate;

/// Orchestrates presentation logic.
@interface PRKPresentationOrchestrator : NSObject

/// @brief Activates presentation logic.
/// @param appDelegate Mandatory application entry point.
- (void)launchWithAppDelegate:(PRKAppDelegate *)appDelegate;

@end
