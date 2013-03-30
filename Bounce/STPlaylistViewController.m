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
#import "UIFont+Bounce.h"
#import <QuartzCore/QuartzCore.h>

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
    
    // Setup styles
    self.friendNameLabel.font = [UIFont openSansSemiboldWithSize:self.friendNameLabel.font.pointSize];
    self.friendNameLabel.textColor = [UIColor grayColor];
    self.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@", [self.friend objectForKey:@"firstName"], [self.friend objectForKey:@"lastName"]];
    
    self.friendIconView.image = [self.friend objectForKey:@"downloadedIconImage"];
    self.friendIconView.contentMode = UIViewContentModeScaleAspectFill;
    self.friendIconView.clipsToBounds = YES;
    self.friendIconView.layer.cornerRadius = self.friendIconView.frame.size.width / 2;
    self.friendIconView.layer.masksToBounds = YES;
    
    self.currentArtistLabel.font = [UIFont openSansLightWithSize:self.currentArtistLabel.font.pointSize];
    self.currentArtistLabel.textColor = [UIColor grayColor];
    
    self.currentAlbumLabel.font = [UIFont openSansLightWithSize:self.currentAlbumLabel.font.pointSize];
    self.currentAlbumLabel.textColor = [UIColor grayColor];
    
    self.currentSongLabel.font = [UIFont openSansLightWithSize:self.currentSongLabel.font.pointSize];
    self.currentSongLabel.textColor = [UIColor grayColor];
    
    self.bounceQueueLabel.font = [UIFont openSansLightWithSize:self.bounceQueueLabel.font.pointSize];
    self.bounceQueueLabel.textColor = [UIColor grayColor];
    
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

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
