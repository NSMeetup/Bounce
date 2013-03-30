//
//  STAppDelegate.h
//  Bounce
//
//  Created by Leah Culver on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@class STLandingViewController;

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) STLandingViewController *viewController;
@property (nonatomic, readonly) Rdio *rdio;

/**
 * For easy access to the Rdio object instance from the rest of our application.
 */
+ (Rdio *)rdioInstance;



@end
