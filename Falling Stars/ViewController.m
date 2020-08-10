//
//  ViewController.m
//  Falling Stars
//
//  Created by Aaron on 4/2/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import "ViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (IS_IPHONE_5)
    {
        player = [[UIImageView alloc] initWithFrame:CGRectMake(130, 438, 70, 70)];
    }
    else{
        player = [[UIImageView alloc] initWithFrame:CGRectMake(130, 350, 70, 70)];
    }
    
    player.backgroundColor = [UIColor greenColor];
    // [player setImage:[UIImage imageNamed:@"image001.jpg"]];
    [self.view addSubview:player];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .0333;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self movePlayer:accelerometerData.acceleration];
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    updateStars = [NSTimer scheduledTimerWithTimeInterval:0.0167
                                                   target:self
                                                 selector:@selector(updateStars)
                                                 userInfo:nil
                                                  repeats:YES];
    
    
    speedTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                   target:self
                                                 selector:@selector(updateSpeed)
                                                 userInfo:nil
                                                  repeats:YES];
     
    
    stars = [[NSMutableArray alloc] init];
    powerUPs = [[NSMutableArray alloc] init];
    powerDOWNs = [[NSMutableArray alloc] init];
    
    // make sure everything is hidden
    gameOverLabel.hidden = YES;
    pauseLabel.hidden = YES;
    menuButton.hidden = YES;
    restartButton.hidden = YES;
    resumeButton.hidden = YES;
    
    // current state
    gameOver = false;
    
    score = 0;
    
    speed = 3.5;
    
    // starting star
    [self addStar];
    
    // keep screen on
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)updateSpeed{
    speed += .125;
    NSLog(@"Speed: %f", speed);
    
    // limit the speed - right speed ?
    if (speed > 10) {
        speed = 10;
    }
}

-(void)movePlayer:(CMAcceleration)acceleration{
    float sensitivity = 20.0f;
    
    // can combine so no new varibles are created
    float xDistance = acceleration.x * sensitivity;
    // float yDistance = acceleration.y *-sensitivity;
    
    CGRect rect = player.frame;
    rect.origin.x += xDistance;
    
    if (rect.origin.x + rect.size.width > 320) {
        rect.origin.x = 320 - rect.size.width;
    }
    if (rect.origin.x < 0) {
        rect.origin.x = 0;
    }
    
    [player setFrame:rect];
    
    // xDistance & yDistance is flipped
    // has to be flipped to work
    // float x = rectangle.position.x + yDistance;
    // float y = rectangle.position.y + xDistance;
    
    // rectangle.position = GLKVector2Make(x,y);
    
}

-(void)addStar{
    
    int posx = arc4random() % 271;
    
    // UIImage *imageStar;
    // imageStar = [[UIImage alloc] initWith]
    
    // change to UIImages
    /*
    UIImageView *imageStar;
    imageStar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    imageStar.backgroundColor = [UIColor redColor];
    [imageStar setImage:[UIImage imageNamed:@"image001.jpg"]];
    [self.view addSubview:imageStar];
     */
    
    UIImageView *star;
    star = [[UIImageView alloc] initWithFrame:CGRectMake(posx, -50, 50, 50)];
    star.backgroundColor = [UIColor yellowColor];
    // [star setImage:[UIImage imageNamed:@"image001.jpg"]];
    [self.view addSubview:star];
    
    [stars addObject:star];
    NSLog(@"%lu", (unsigned long)stars.count);
    
    int rand = arc4random() % 100;
    if (rand < 5) {
        [self addPowerUP];
        NSLog(@"added");
    }
    if (rand > 4 && rand < 10) {
        [self addPowerDOWN];
    }
}

-(void)addPowerUP{
    int posx = arc4random() % 271;
    
    UIImageView *powerUP;
    powerUP = [[UIImageView alloc] initWithFrame:CGRectMake(posx, -50, 25, 25)];
    powerUP.backgroundColor = [UIColor blueColor];
    // [star setImage:[UIImage imageNamed:@"image001.jpg"]];
    [self.view addSubview:powerUP];
    
    // set random speed
    powerUP.tag = (arc4random() % 10) + 1;
    
    [powerUPs addObject:powerUP];
    NSLog(@"%lu", (unsigned long)powerUPs.count);
}

-(void)addPowerDOWN{
    int posx = arc4random() % 271;
    
    UIImageView *powerDOWN;
    powerDOWN = [[UIImageView alloc] initWithFrame:CGRectMake(posx, -50, 25, 25)];
    powerDOWN.backgroundColor = [UIColor redColor];
    // [star setImage:[UIImage imageNamed:@"image001.jpg"]];
    [self.view addSubview:powerDOWN];
    
    // set random speed
    powerDOWN.tag = (arc4random() % 10) + 1;
    
    [powerDOWNs addObject:powerDOWN];
    NSLog(@"%lu", (unsigned long)powerDOWNs.count);
}

// updates everything
-(void)updateStars{
    // make sure the array has shapes in it
    
    if (stars.count) {
        // update for each shape
        for (int i = 0; i<stars.count; i++) {
            UIImageView *star = [stars objectAtIndex:i];
            
            // update speed
            CGRect rect = star.frame;
            rect.origin.y += speed;
            [star setFrame:rect];
            
            // add star once old star gets a certain distance
            // change 150 to any other number to effect how fast a new star appears
            if (star.frame.origin.y > 150 && star.tag == 0) {
                [self addStar];
                // stops old stars from adding anymore than one star
                [star setTag:1];
            }
            
            // ??
            if(CGRectIntersectsRect(player.frame,star.frame)){
                NSLog(@"collision");
                [stars removeObject:star];
                [star removeFromSuperview];
                [self updateScore];
            }
            else if (star.frame.origin.y + star.frame.size.height > self.view.frame.size.height) {
                // remove from array
                // [stars removeObject:star];
                
                // because user lost
                // [stars removeAllObjects];
                // remove from view ?
                // [star removeFromSuperview];
                
                // tell user
                gameOverLabel.hidden = NO;
                menuButton.hidden = NO;
                restartButton.hidden = NO;
                [self.view addSubview:gameOverLabel];
                [self.view addSubview:menuButton];
                [self.view addSubview:restartButton];
                [updateStars invalidate];
                [speedTimer invalidate];
                
                // update game state
                gameOver = true;
                
                // remove from screen / memory
                // [self.view delete:star];
                // [star release];
                
                // stop user
                self.motionManager = nil;
                
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                if ([prefs objectForKey:@"Scores"]) {
                    scoreArray = [[prefs objectForKey:@"Scores"] mutableCopy];
                }
                else{
                    scoreArray = [[NSMutableArray alloc] init];
                }
                
                // update scores for scoreview
                // [scoreArray addObject: [NSString stringWithFormat:@"Score: %@", scoreLabel.text] ];
                [scoreArray addObject: scoreLabel.text];
                
                [prefs setObject:scoreArray forKey:@"Scores"];
                
                // app review stuff
                if ([prefs integerForKey:@"AppReview"] == 3) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like the App?"
                                                                    message:@"Review it on the app store!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"No Thanks"
                                                          otherButtonTitles:@"Ya!", nil];
                    [alert show];
                }
                
                [prefs setInteger:[prefs integerForKey:@"AppReview"]+1 forKey:@"AppReview"];
                
                // stops it from getting too high and passibly crashing
                if ([prefs integerForKey:@"AppReview"] == 5) {
                    [prefs setInteger:4 forKey:@"AppReview"];
                }
                
                // report score - Apple only sets highest score
                [self reportHighScore:score];
                
                int valueToSend = 0;
                // add all the squares together
                if ([prefs objectForKey:@"Scores"]) {
                    NSArray *pointsArray = [[prefs objectForKey:@"Scores"] mutableCopy];
                    for (int i = 0; i < pointsArray.count; i++) {
                        int value = [[pointsArray objectAtIndex:i] intValue];
                        valueToSend += value;
                    }
                }
                
                // send how many squares were collected
                [self reportSquaresCollected:valueToSend];
                
            }
             
        }
    }
    
    // update power ups / downs if present
    if (powerUPs.count) {
        for (int i = 0; i<powerUPs.count; i++) {
            UIImageView *powerUP = [powerUPs objectAtIndex:i];
            
            // update speed
            // random speed?
            CGRect rect = powerUP.frame;
            rect.origin.y += powerUP.tag;
            [powerUP setFrame:rect];
            
            if (CGRectIntersectsRect(player.frame, powerUP.frame)) {
                [powerUPs removeObject:powerUP];
                [powerUP removeFromSuperview];
                
                if (!(player.frame.origin.y + player.frame.size.height + 10 > [[UIScreen mainScreen] bounds].size.height)) {
                    [player setFrame:CGRectMake(player.frame.origin.x,
                                                player.frame.origin.y,
                                                player.frame.size.width + 10,
                                                player.frame.size.height + 10)];
                }
            }
            
            if (powerUP.frame.origin.y + powerUP.frame.size.height > self.view.frame.size.height) {
                [powerUPs removeObject:powerUP];
                [powerUP removeFromSuperview];
            }
        }
    }
    
    if (powerDOWNs.count) {
        for (int i = 0; i<powerDOWNs.count; i++) {
            UIImageView *powerDown = [powerDOWNs objectAtIndex:i];
            
            // update speed
            // random speed?
            CGRect rect = powerDown.frame;
            rect.origin.y += powerDown.tag;
            [powerDown setFrame:rect];
            
            if (CGRectIntersectsRect(player.frame, powerDown.frame)) {
                [powerDOWNs removeObject:powerDown];
                [powerDown removeFromSuperview];
                
                if (!(player.frame.size.width - 10 == 10)) {
                    [player setFrame:CGRectMake(player.frame.origin.x,
                                                player.frame.origin.y,
                                                player.frame.size.width - 10,
                                                player.frame.size.height - 10)];
                }
            }
            
            if (powerDown.frame.origin.y + powerDown.frame.size.height > self.view.frame.size.height) {
                [powerDOWNs removeObject:powerDown];
                [powerDown removeFromSuperview];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) //review the app
    {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"https://itunes.apple.com/us/app/falling-squares!/id892508506?ls=1&mt=8"]];
    }
}

- (void) reportHighScore:(NSInteger) highScore {
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* scoreToSend = [[GKScore alloc] initWithLeaderboardIdentifier:@"BestRun1"];
        scoreToSend.value = highScore;
        [GKScore reportScores:@[scoreToSend] withCompletionHandler:^(NSError *error) {
            
            NSLog(@"Score was sent!!!");
            
            if (error) {
                // handle error
            }
        }];
    }
}

- (void) reportSquaresCollected:(NSInteger) highScore {
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore* scoreToSend = [[GKScore alloc] initWithLeaderboardIdentifier:@"SquaresCollected1"];
        scoreToSend.value = highScore;
        [GKScore reportScores:@[scoreToSend] withCompletionHandler:^(NSError *error) {
            
            NSLog(@"Squares were sent!!!");
            
            if (error) {
                // handle error
            }
        }];
    }
}

-(void)updateScore{
    score++;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
}

// to pause game
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // don't want it to come up when gameover is up
    if (!gameOver) {
        // show everything
        pauseLabel.hidden = NO;
        menuButton.hidden = NO;
        restartButton.hidden = NO;
        resumeButton.hidden = NO;
        
        // add subview may be creating layers of labels...
        [self.view addSubview:pauseLabel];
        [self.view addSubview:menuButton];
        [self.view addSubview:restartButton];
        [self.view addSubview:resumeButton];
        
        // stop stars
        [updateStars invalidate];
        [speedTimer invalidate];
        // stop player
        self.motionManager = nil;
    }
}

-(IBAction)resumeGame{
    // hide everything
    pauseLabel.hidden = YES;
    menuButton.hidden = YES;
    restartButton.hidden = YES;
    resumeButton.hidden = YES;
    
    // update stars again
    updateStars = [NSTimer scheduledTimerWithTimeInterval:0.0167
                                                   target:self
                                                 selector:@selector(updateStars)
                                                 userInfo:nil
                                                  repeats:YES];
    speedTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(updateSpeed)
                                                userInfo:nil
                                                 repeats:YES];
    
    // update player again
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .0333;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self movePlayer:accelerometerData.acceleration];
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
}

-(IBAction)restartGame{
    // hide everything
    gameOverLabel.hidden = YES;
    pauseLabel.hidden = YES;
    menuButton.hidden = YES;
    restartButton.hidden = YES;
    resumeButton.hidden = YES;
    // [gameOverLabel removeFromSuperview];
    // [pauseLabel removeFromSuperview];
    // [menuButton removeFromSuperview];
    // [restartButton removeFromSuperview];
    // [resumeButton removeFromSuperview];
    
    // make all the objects dissapear from screen
    if (stars.count) {
        // update for each shape
        for (int i = 0; i<stars.count; i++) {
            UIImageView *star = [stars objectAtIndex:i];
            // make all stars disapper
            [star removeFromSuperview];
            
        }
    }
    if (powerUPs.count) {
        // update for each shape
        for (int i = 0; i<powerUPs.count; i++) {
            UIImageView *powerUP = [powerUPs objectAtIndex:i];
            // make all stars disapper
            [powerUP removeFromSuperview];
            
        }
    }
    if (powerDOWNs.count) {
        // update for each shape
        for (int i = 0; i<powerDOWNs.count; i++) {
            UIImageView *powerDown = [powerDOWNs objectAtIndex:i];
            // make all stars disapper
            [powerDown removeFromSuperview];
            
        }
    }
    
    // clear all arrays
    [stars removeAllObjects];
    [powerUPs removeAllObjects];
    [powerDOWNs removeAllObjects];
    
    // reset player
    if (IS_IPHONE_5)
    {
         [player setFrame:CGRectMake(130, 438, 70, 70)];
    }
    else{
         [player setFrame:CGRectMake(130, 350, 70, 70)];
    }
    
    // update player
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .0333;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self movePlayer:accelerometerData.acceleration];
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    // update stars again
    updateStars = [NSTimer scheduledTimerWithTimeInterval:0.0167
                                                   target:self
                                                 selector:@selector(updateStars)
                                                 userInfo:nil
                                                  repeats:YES];
    speedTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(updateSpeed)
                                                userInfo:nil
                                                 repeats:YES];
    
    // reset scorelabel
    scoreLabel.text = @"0";
    score = 0;
    speed = 3.5;
    
    // reset game state
    gameOver = false;
    
    // restart game by adding a star
    [self addStar];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [updateStars invalidate];
    [speedTimer invalidate];
    self.motionManager = nil;
    
    // screen can sleep now
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
