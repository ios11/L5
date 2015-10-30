//
//  POSHTTPRequest+PRK.h
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <POSRx/POSRx.h>

typedef id (^PRKHTTPRequestResponseHandler)(POSHTTPResponse *response, NSError **error);
typedef id (^PRKHTTPRequestResponseDataHandler)(NSData *responseData, NSError **error);

@interface POSHTTPRequest (PRK)

/// @brief Block for handling response from HTTPGateway.
/// @remarks It is your job to validate both metadata and data.
/// @remarks Response block may signal about error in out error parameter or throwing NSException.
/// @remarks If block returns nil, then its signal completes without values.
/// @remarks Default handler will check, that status code has 2XX value and then use
///          responseDataHandler block to process data.
/// @return Value which will be emitted by signal.
@property (nonatomic, copy, setter = prk_setResponseHandler:) PRKHTTPRequestResponseHandler prk_responseHandler;

/// @brief Block for handling data in the response from HTTPGateway.
/// @remarks Response block may signal about error in out error parameter or throwing NSException.
/// @remarks If block returns nil, then its signal completes without values.
/// @remarks Default handler returns responseData.
/// @return Value which will be emitted by signal.
@property (nonatomic, copy, setter = prk_setResponseDataHandler:) PRKHTTPRequestResponseDataHandler prk_responseDataHandler;

@end


/// Helpers around NSHTTPURLResponse.
@interface NSHTTPURLResponse (PRK)

/// @return YES if status code is in range [200..299].
- (BOOL)contains2XXStatusCode;

@end