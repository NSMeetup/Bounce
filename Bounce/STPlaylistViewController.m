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
    
    [self findOrCreatePlaylist];
}

- (void) findOrCreatePlaylist
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[Settings settings] userKey] forKey:@"user"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"getUserPlaylists" withParameters:params delegate:self];
}

- (void) createPlaylistWithName:(NSString*) playlistName
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:playlistName forKey:@"name"];
    [params setObject:@"Bounce Battle!" forKey:@"description"];
    [params setObject:@"" forKey:@"tracks"];
    [[STAppDelegate rdioInstance] callAPIMethod:@"createPlaylist" withParameters:params delegate:self];
}

#pragma mark -
#pragma mark RDAPIRequestDelegate

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data
{
    NSLog(@"%@", data);
    
    NSString *method = [request.parameters objectForKey:@"method"];
    
    if ([method isEqualToString: @"getUserPlaylists"]) {
        
        NSString *playlistName1 = [NSString stringWithFormat:@"Bounce %@ vs %@ %@",
                                   [[Settings settings] user],
                                   [self.friend objectForKey:@"firstName"],
                                   [self.friend objectForKey:@"lastName"]];
        
        NSString *playlistName2 = [NSString stringWithFormat:@"Bounce %@ %@ vs %@",
                                  [self.friend objectForKey:@"firstName"],
                                  [self.friend objectForKey:@"lastName"],
                                  [[Settings settings] user]];
        
        BOOL foundPlaylist = NO;
        for (NSDictionary* playlist in data) {
            NSString* name = [playlist objectForKey:@"name"];
            
            if([name isEqual: playlistName1] || [name isEqual: playlistName2]) {
                foundPlaylist = YES;
                self.playlist = playlist;
                break;
            }
        }
        
        if (!foundPlaylist) {
            [self createPlaylistWithName:playlistName1];
        }
    } else if ([method isEqualToString: @"createPlaylist"]) {
        self.playlist = data;
    }
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    NSLog(@"error");
}

@end
