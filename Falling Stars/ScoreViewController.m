//
//  ScoreViewController.m
//  Falling Stars
//
//  Created by Aaron on 6/14/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController
@synthesize scoreArray;
@synthesize scoreArrayToUse;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [self.scoreArrayToUse count];
}

//4
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //5
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //5.1 you do not need this if you have set SettingsCell as identifier in the storyboard (else you can remove the comments on this code)
    //if (cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    //   }
    
    //6
    NSString *string;
    string = [self.scoreArrayToUse objectAtIndex:indexPath.row];
    
    //7
    /*
    if ([string hasPrefix:@"Score:"]) {
        [cell.textLabel setText: [NSString stringWithFormat:@"%@", string]];
    }
    else{
        [cell.textLabel setText: [NSString stringWithFormat:@"Score: %@", string]];
    }
     */
    
    [cell.textLabel setText: [NSString stringWithFormat:@"Score: %@", string]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    /*
     if (indexPath.row < 2) {
     [cell.detailTextLabel setText:@"a"];
     }
     else {
     [cell.detailTextLabel setText:@"b"];
     }
     */
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.scoreArrayToUse = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // [prefs setObject:array forKey:@"addObject"];
    
    // [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"myArray"];
    
    //1
    self->tableView2.dataSource = self;
    
    //2
    self.scoreArray = [prefs objectForKey:@"Scores"];
    
    // sort them
    self.scoreArray = [self.scoreArray sortedArrayUsingFunction:sortScores context:NULL];
    // add them to a NSMutableArray to shorten
    [self.scoreArrayToUse addObjectsFromArray:self.scoreArray];
    
    // set gamesplayed textfield
    gamesPlayed.text = [NSString stringWithFormat:@"Games Played - %lu", (unsigned long)self.scoreArray.count];
    
    // set squares collected
    int squaresCollected = 0;
    for (int i = 0; i < self.scoreArray.count; i++) {
        int cellCount = [[self.scoreArray objectAtIndex:i] intValue];
        
        // NSLog(@"cell %i, value: %i", i, cellCount);
        
        squaresCollected += cellCount;
    }
    totalCollected.text = [NSString stringWithFormat:@"Squares Collected - %i", squaresCollected];
    
    gameCenterButton.transform = CGAffineTransformMakeRotation(M_PI / -2);
    
    
    // shorten scoreArray to first 20 (top 20 scores)
    NSMutableArray *arrayToDelete = [[NSMutableArray alloc] init];
    
    int theCount = self.scoreArrayToUse.count;
    
    for (int i = 0; i < theCount; i++) {
        if (i >= 20) {
            [arrayToDelete addObject:[self.scoreArrayToUse objectAtIndex:i]];
        }
    }
    
    [self.scoreArrayToUse removeObjectsInArray:arrayToDelete];
    
}

NSInteger sortScores(id id1, id id2, void *context)
{
    // Sort Function
    NSString* name1 = (NSString*)id1;
    NSString* name2 = (NSString*)id2;
    
    // return ([name2 compare:name1]);
    return ([name2 compare:name1 options:NSNumericSearch]);
}

-(IBAction)presentGameCenterLeaderboard{
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.gameCenterDelegate = self;
    [self presentViewController:gameCenterViewController animated:YES completion:^{
       // do something
    }];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    if(gameCenterViewController) {
        [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"GCVC: DidFinish ...");
    } else {
        NSLog(@"%s [Controller Error]", __PRETTY_FUNCTION__);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
