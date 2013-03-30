//
//  STPlaylistViewController.m
//  Bounce
//
//  Created by Paul Silvis on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import "STPlaylistViewController.h"
#import "STAppDelegate.h"
#import "Settings.h"
#import <Rdio/Rdio.h>

@interface STPlaylistViewController () <RdioDelegate, RDAPIRequestDelegate>

@end

@implementation STPlaylistViewController

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
    [super viewDidLoad];
    [self createPlaylist];
    // Do any additional setup after loading the view from its nib.
}

- (void) createPlaylist
{
    self.tracks = @"";
    NSString *playlistName = [NSString stringWithFormat:@"Bounce %@ %@ vs %@",
                              [self.friend objectForKey:@"firstName"],
                              [self.friend objectForKey:@"lastName"],
                              [[Settings settings] user]];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:playlistName forKey:@"name"];
    [params setObject:@"Bounce Battle!" forKey:@"description"];
    [params setObject:self.tracks forKey:@"tracks"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"createPlaylist" withParameters:params delegate:self];
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
