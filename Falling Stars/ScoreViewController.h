//
//  ScoreViewController.h
//  Falling Stars
//
//  Created by Aaron on 6/14/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ScoreViewController : UIViewController <UITableViewDataSource, GKGameCenterControllerDelegate> {
    IBOutlet UITableView *tableView2;
    
    IBOutlet UITextField *gamesPlayed;
    IBOutlet UITextField *totalCollected;
    
    IBOutlet UILabel *scoreLabel;
    IBOutlet UIButton *backButton;
    
    IBOutlet UIButton *gameCenterButton;
}

@property (strong, nonatomic) NSArray *scoreArray;
@property (strong, nonatomic) NSMutableArray *scoreArrayToUse;

-(IBAction)presentGameCenterLeaderboard;

@end
