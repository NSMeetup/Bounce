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
#import <QuartzCore/QuartzCore.h>
#import "UIFont+Bounce.h"
#import "STPlaylistViewController.h"

@interface STBaseViewController () <RdioDelegate, RDAPIRequestDelegate>

@property (nonatomic, retain) NSMutableArray *friends;

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
    if ([[Settings settings] user] != nil) {
        [self pullListOfFriends];
    }
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
    self.friends = data;
    [self.tableView reloadData];
    
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    NSLog(@"error");
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FriendsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSMutableDictionary *friend = [self.friends objectAtIndex:indexPath.row];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 14.0, self.view.frame.size.width - 100.0, 20.0)];
    name.font = [UIFont openSansSemiboldWithSize:16.0];
    name.textColor = [UIColor grayColor];
    name.text = [NSString stringWithFormat:@"%@ %@", [friend objectForKey:@"firstName"], [friend objectForKey:@"lastName"]];
    [cell.contentView addSubview:name];
    
    UILabel *lastBounced = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 34.0, self.view.frame.size.width - 100.0, 20.0)];
    lastBounced.font = [UIFont openSansLightWithSize:13.0];
    lastBounced.textColor = [UIColor grayColor];
    lastBounced.text = [NSString stringWithFormat:@"Bounce with %@...", [friend objectForKey:@"firstName"]];
    [cell.contentView addSubview:lastBounced];
    
    if ([friend objectForKey:@"downloadedIconImage"]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 13.0, 40.0, 40.0)];
        imageView.image = [friend objectForKey:@"downloadedIconImage"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
    } else {
        NSURL *imageURL = [NSURL URLWithString:[friend objectForKey:@"icon250"]];
        NSLog(@"%@", imageURL);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [friend setObject:[UIImage imageWithData:imageData] forKey:@"downloadedIconImage"];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *friend = [self.friends objectAtIndex:indexPath.row];
    
    STPlaylistViewController *playlistController = [[STPlaylistViewController alloc] initWithNibName:@"STPlaylistViewController" bundle:nil];
    playlistController.friend = friend;
    [self.navigationController pushViewController:playlistController animated:YES];
}

@end
