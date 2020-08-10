//
//  TitleViewController.m
//  Falling Stars
//
//  Created by Aaron on 8/22/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import "TitleViewController.h"

@implementation TitleViewController

-(void)viewDidLoad{
    titleLabel.alpha = 0;
    playButton.alpha = 0;
    scoreButton.alpha = 0;
    infoButon.alpha = 0;
    
    [UIView animateWithDuration:1.0f animations:^{
        titleLabel.alpha = 2.0;
        playButton.alpha = 2.0;
        scoreButton.alpha =2.0;
        infoButon.alpha = 2.0;
    }];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                             target:self
                                           selector:@selector(changeBackground)
                                           userInfo:nil
                                            repeats:YES];
    
    [self changeBackground];
    
}

-(void)changeBackground{
    
    float red = (float)(arc4random() % 11) / 10;
    float green = (float)(arc4random() % 11) / 10;
    float blue = (float)(arc4random() % 11) / 10;
    
    
    [UIView animateWithDuration:1.0f animations:^{
        background.backgroundColor = [UIColor colorWithRed:red
                                                     green:green
                                                      blue:blue
                                                     alpha:1.0];
    }];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
}

@end
