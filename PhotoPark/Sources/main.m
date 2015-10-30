//
//  main.m
//  PhotoPark
//
//  Created by Pavel Osipov on 21.09.15.
//  Copyright © 2015 Pavel Osipov. All rights reserved.
//

#import "PRKAppDelegate.h"
#import <Classy/Classy.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        CASStyler.defaultStyler.filePath = [[NSBundle mainBundle] pathForResource:@"Default.cas" ofType:nil];
#if TARGET_IPHONE_SIMULATOR
        NSString *stylesheetPath = CASAbsoluteFilePath(@"Presentation/Styles/Default.cas");
        [CASStyler defaultStyler].watchFilePath = stylesheetPath;
#endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([PRKAppDelegate class]));
    }
}
