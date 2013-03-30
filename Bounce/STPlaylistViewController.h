//
//  STPlaylistViewController.h
//  Bounce
//
//  Created by Paul Silvis on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPlaylistViewController : UIViewController

@property(nonatomic, retain) NSDictionary *friend;
@property(nonatomic, retain) NSDictionary *playlist;

@property (nonatomic, weak) IBOutlet UIImageView *friendIconView;
@property (nonatomic, weak) IBOutlet UILabel *friendNameLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;

@end
