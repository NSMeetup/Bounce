//
//  STBaseViewController.m
//  Bounce
//
//  Created by Leah Culver on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import "STBaseViewController.h"
#import "STAppDelegate.h"
#import "STLandingViewController.h"
#import "Settings.h"

@interface STBaseViewController () <RdioDelegate, RDAPIRequestDelegate>

@end

@implementation STBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self pullListOfFriends];
}

- (void)pullListOfFriends
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[Settings settings] userKey] forKey:@"user"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"userFollowing" withParameters:params delegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Present login view if user isn't logged in yet
    if ([[Settings settings] user] == nil) {
        STLandingViewController *landingViewController = [[STLandingViewController alloc] initWithNibName:@"STLandingViewController" bundle:nil];
        [self.navigationController pushViewController:landingViewController animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
