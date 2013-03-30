//
//  STBaseViewController.m
//  Bounce
//
//  Created by Leah Culver on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import "STBaseViewController.h"
#import "STLandingViewController.h"
#import "Settings.h"

@interface STBaseViewController ()

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

@end
