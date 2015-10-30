//
//  PRKTracker.h
//  PhotoPark
//
//  Created by Pavel Osipov on 29.03.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PRKEnvironment;
@protocol PRKKeyedStore;

/// Specifies event category to measure user engagement.
/// It is very interesting to know when user customize something
/// in the application UI/Settings or even in the cloud.
typedef NS_ENUM(int, PRKTrackerEventType) {
    PRKTrackerEventTypeUX          = 11, /// < Nonmodifiable action in the app (button clickss, opening views etc.)
    PRKTrackerEventTypeUXModify    = 12, /// < UI customization (view sorting change, app settings change etc.)
    PRKTrackerEventTypeCloud       = 21, /// < Nonmodifiable interaction with the cloud (login, loading photos etc.)
    PRKTrackerEventTypeCloudModify = 22  /// < Cloud updates (add/update/delete content, accept invites etc.)
};

/// Tacks statistics about application usage.
@protocol PRKTracker <NSObject>

/// @brief Short version of the event tracking method.
/// @see trackEventWithCategory:action:label:value:params
/// @param type Type of the action.
/// @param action Mandatory verb which describes concrete action from the business perspective, for ex. @"signin".
- (void)trackEventWithType:(PRKTrackerEventType)type
                    action:(NSString *)action;

/// @brief Tracks application event.
/// @param type Type of the action.
/// @param action Mandatory verb which describes concrete action from the business perspective, for ex. @"signin".
/// @param label Optional subtype of the action, for ex. @"dropbox".
/// @param value Optional value of the action, for ex. @(canceled).
/// @param params Optional additional parameters of the event.
- (void)trackEventWithType:(PRKTrackerEventType)type
                    action:(NSString *)action
                     label:(NSString *)label
                     value:(NSNumber *)value
                    params:(NSDictionary *)params;

/// @brief Tracks time which application spent to perform some action.
/// @param type Type of the action.
/// @param name Mandatory verb which describes concrete action from the business perspective, for ex. @"signin".
/// @param label Optional subtype of the action, for ex. @"dropbox".
- (void)trackTimingWithType:(PRKTrackerEventType)type
               timeInterval:(NSTimeInterval)interval
                       name:(NSString *)name
                      label:(NSString *)label;

/// @brief Tracks application errors.
/// @param error Mandatory error instance.
/// @param action Optional name of the failed action.
- (void)trackError:(NSError *)error
            action:(NSString *)action;

@end

@interface PRKTracker : NSObject <PRKTracker>

/// @brief The designated initializer.
/// @param store Mandatory store to persist state netween app launches.
/// @param environment Mandatory environment.
/// @return Tracker instance scheduled in the same thread as store.
- (instancetype)initWithStore:(id<PRKKeyedStore>)store
                  environment:(id<PRKEnvironment>)environment;

@end
