//
//  AppDelegate.h
//  Emerald
//
//  Created by ColtBoys on 12/21/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"
#import "Audio.h"
#import "LocalData.h"
@class Audio;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    int feed,pic,vid,more,audio;
    
    //Audio Streamer
    NSDictionary *streamerDict;
    NSTimer *timerPlayer;
    UIActivityIndicatorView *loading;
    UILabel *lblTimeLeft;
    UILabel *lblTimeEllasped;
    UIProgressView *slider;
    Audio *CurrentController;
}
- (void)AudioStreamContent:(NSDictionary *)infos withView:(UIView *)StreamingView andControllerIndex:(int)index andController:(Audio *)controller;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL isVideoPlaying;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic,retain) AudioStreamer *streamer;
@property (nonatomic,retain) UIView *streamerView;
@property (nonatomic,assign) int CurrentAudioControllerIndex;
@end
