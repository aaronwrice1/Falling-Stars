//
//  AppDelegate.h
//  Falling Stars
//
//  Created by Aaron on 4/2/14.
//  Copyright (c) 2014 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>{
    AVAudioPlayer *player;
}

@property (strong, nonatomic) UIWindow *window;

@end
