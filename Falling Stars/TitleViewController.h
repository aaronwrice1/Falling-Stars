//
//  TitleViewController.h
//  Falling Stars
//
//  Created by Aaron on 8/22/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewController : UIViewController{
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *scoreButton;
    IBOutlet UIButton *infoButon;
    
    IBOutlet UIImageView *background;
    NSTimer *timer;
}

@end
