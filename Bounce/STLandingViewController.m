//
//  STLandingViewController.m
//  Bounce
//
//  Created by Leah Culver on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import "STLandingViewController.h"
#import "STAppDelegate.h"
#import "Settings.h"

@interface STLandingViewController () <RdioDelegate, RDAPIRequestDelegate>

@end

@implementation STLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"Artist,Album,Track" forKey:@"types"];
    [params setObject:@"Calvin" forKey:@"query"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"search" withParameters:params delegate:self];*/
}

- (IBAction)loginButtonPressed:(id)sender
{
    /**
     * Display the login modal so the user can log in.
     */
    [[STAppDelegate rdioInstance] setDelegate:self];
    [[STAppDelegate rdioInstance] authorizeFromController:self];
}

#pragma mark -
#pragma mark RdioDelegate methods

/**
 * The user has successfully authorized the application, so we should store the access token
 * and any other information we might want access to later.
 */
- (void)rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken
{
    [[Settings settings] setUser:[NSString stringWithFormat:@"%@ %@", [user valueForKey:@"firstName"], [user valueForKey:@"lastName"]]];
    [[Settings settings] setAccessToken:accessToken];
    [[Settings settings] setUserKey:[user objectForKey:@"key"]];
    [[Settings settings] setIcon:[user objectForKey:@"icon"]];
    [[Settings settings] save];
    
    [self.navigationController dismissViewControllerAnimated:NO completion:NULL];
}

/**
 * Authentication failed so we should alert the user.
 */
- (void)rdioAuthorizationFailed:(NSString *)message {
    NSLog(@"Rdio authorization failed: %@", message);
}

#pragma mark -
#pragma mark RDAPIRequestDelegate

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {

    NSLog(@"%@", request.parameters);
    NSLog(@"%@", data);
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    NSLog(@"error");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
