//
//  GCHelper.h
//  Isolate!
//
//  Created by Aaron on 6/27/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID;
-(void)inviteReceived;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    
    NSMutableDictionary *playersDict;
    
    GKInvite *pendingInvite;
    NSArray *pendingPlayersToInvite;
}

@property (assign, readonly) BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) NSMutableDictionary *playersDict;
@property (retain) GKInvite *pendingInvite;
@property (retain) NSArray *pendingPlayersToInvite;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GCHelperDelegate>)theDelegate;

@end
