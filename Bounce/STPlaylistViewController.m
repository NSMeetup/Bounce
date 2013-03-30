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
    self.tracks = @""; // @todo
    
    [self findOrCreatePlaylist];
    // Do any additional setup after loading the view from its nib.
}

- (void) findOrCreatePlaylist
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[Settings settings] userKey] forKey:@"user"];
    [params setObject:@"Bounce Battle!" forKey:@"description"];
    [params setObject:self.tracks forKey:@"tracks"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"getUserPlaylists" withParameters:params delegate:self];
    
    NSString *playlistName = [NSString stringWithFormat:@"Bounce %@ %@ vs %@",
                               [self.friend objectForKey:@"firstName"],
                               [self.friend objectForKey:@"lastName"],
                               [[Settings settings] user]];

    //NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:playlistName forKey:@"name"];
    [params setObject:@"Bounce Battle!" forKey:@"description"];
    [params setObject:self.tracks forKey:@"tracks"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"createPlaylist" withParameters:params delegate:self];
}

- (void) createPlaylistWithName:(NSString*) playlist_name
{
    NSLog(@"Creating playlist with name %@",playlist_name);
}
- (void) usePlaylist:(NSString *)key
{
    NSLog(@"Found playlist with key %@",key);
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSLog(@"Searching for %@",searchText);
}


#pragma mark -
#pragma mark RDAPIRequestDelegate

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    
    if ([[request.parameters objectForKey:@"method"] isEqual: @"getUserPlaylists"]) {
        NSString *playlistName1 = [NSString stringWithFormat:@"Bounce %@ %@ vs %@",
                                  [self.friend objectForKey:@"firstName"],
                                  [self.friend objectForKey:@"lastName"],
                                  [[Settings settings] user]];
        
        NSString *playlistName2 = [NSString stringWithFormat:@"Bounce %@ vs %@ %@",
                                   [[Settings settings] user],
                                   [self.friend objectForKey:@"firstName"],
                                   [self.friend objectForKey:@"lastName"]];
        
        BOOL foundPlaylist = NO;
        for(NSDictionary* playlist in data) {
            NSString* name = [playlist objectForKey:@"name"];
            
            if([name isEqual: playlistName1] || [name isEqual: playlistName2]) {
                foundPlaylist = YES;
                [self usePlaylist:[playlist objectForKey:@"key"]];
                break;
            }
        }
        
        if (!foundPlaylist) {
            [self createPlaylistWithName:playlistName1];
        }
    }
    
    //NSLog(@"%@", request.parameters);
    //NSLog(@"%@", data);
    
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
