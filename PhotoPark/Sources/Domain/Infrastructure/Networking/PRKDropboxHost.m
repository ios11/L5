//
//  PRKDropboxHost.m
//  PhotoPark
//
//  Created by Pavel Osipov on 27.10.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKDropboxHost.h"
#import "PRKAuthenticator.h"
#import "PRKCloudTypes.h"
#import "NSError+PRKDomain.h"
#import <DropboxSDK/DropboxSDK.h>

@interface POSHTTPRequestOptions (PRKDropboxHost)
+ (POSHTTPRequestOptions *)prk_optinosWithCredentials:(id<MPOAuthCredentialStore>)credentials;
@end

@interface PRKDropboxHost ()
@property (nonatomic, readonly) id<PRKAuthenticator> authenticator;
@property (nonatomic) POSHTTPRequestOptions *HTTPOptions;
@end

@implementation PRKDropboxHost

POSRX_DEADLY_INITIALIZER(initWithGateway:(id<POSHTTPGateway>)gateway
                         URL:(NSURL *)URL
                         tracker:(id<PRKTracker>)tracker
                         hostLabel:(NSString *)hostLabel)

- (instancetype)initWithGateway:(id<POSHTTPGateway>)gateway
                            URL:(NSURL *)URL
                        tracker:(id<PRKTracker>)tracker
                  authenticator:(id<PRKAuthenticator>)authenticator {
    POSRX_CHECK(authenticator);
    if (self = [super initWithGateway:gateway
                                  URL:URL
                              tracker:tracker
                            hostLabel:PRKStringFromCloudType(PRKCloudTypeDropbox)]) {
        _authenticator = authenticator;
        RAC(self, HTTPOptions) = [[authenticator.credentialsSignal deliverOn:self.scheduler]
                                  map:^id(id<MPOAuthCredentialStore> credentials) {
                                      return [POSHTTPRequestOptions prk_optinosWithCredentials:credentials];
                                  }];
    }
    return self;
}

#pragma mark PRKHost

- (RACSignal *)pushRequest:(POSHTTPRequest *)request
                   options:(POSHTTPRequestExecutionOptions *)options {
    if (!_HTTPOptions) {
        return [RACSignal error:[NSError prk_authorizationErrorWithCloudType:PRKCloudTypeDropbox reason:nil]];
    }
    return [super
            pushRequest:request
            options:[POSHTTPRequestExecutionOptions
                     merge:options
                     withHTTPOptions:_HTTPOptions]];
}

@end

#pragma mark - POSHTTPRequestOptions (PRKDropboxHost)

@implementation POSHTTPRequestOptions (PRKDropboxHost)

+ (POSHTTPRequestOptions *)prk_optinosWithCredentials:(id<MPOAuthCredentialStore>)credentials {
    if (!credentials.accessToken || !credentials.accessTokenSecret) {
        return nil;
    }
    NSString *authorizationHeader = [NSString stringWithFormat:@
        "OAuth oauth_version=\"1.0\", "
        "oauth_signature_method=\"%@\", "
        "oauth_consumer_key=\"%@\", "
        "oauth_token=\"%@\", "
        "oauth_signature=\"%@&%@\"",
        [credentials credentialNamed:kMPOAuthSignatureMethod],
        [credentials consumerKey],
        [credentials accessToken],
        [credentials consumerSecret],
        [credentials accessTokenSecret]];
    return [[POSHTTPRequestOptions alloc]
            initWithHeaderFields:@{@"Authorization": authorizationHeader}];
}

@end
