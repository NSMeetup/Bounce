//
//  STLandingViewController.h
//  Bounce
//
//  Created by Leah Culver on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^STLandingViewControllerCompletion)(BOOL success);

@interface STLandingViewController : UIViewController

- (IBAction)loginButtonPressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil completion:(STLandingViewControllerCompletion)completion;

@end
