//
//  ViewController.h
//  Falling Stars
//
//  Created by Aaron on 4/2/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>

#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController {
    UIImageView *player;
    NSTimer *updateStars;
    NSTimer *speedTimer;
    
    NSMutableArray *stars;
    
    NSMutableArray *powerUPs;
    NSMutableArray *powerDOWNs;
    
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *gameOverLabel;
    IBOutlet UILabel *pauseLabel;
    
    IBOutlet UIButton *resumeButton;
    IBOutlet UIButton *restartButton;
    IBOutlet UIButton *menuButton;
    
    bool gameOver;
    int score;
    
    float speed;
    
    NSMutableArray *scoreArray;
}

-(IBAction)resumeGame;
-(IBAction)restartGame;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end
