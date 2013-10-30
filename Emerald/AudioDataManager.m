//
//  AudioDataManager.m
//  Emerald
//
//  Created by ColtBoys on 1/20/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "AudioDataManager.h"
#import "Tools.h"
@implementation AudioDataManager
@synthesize delegate;
@synthesize UrlSource;
-(void)RefreshInfo{
    if ([Tools isNetWorkConnectionAvailable]) {
        ClassicAudio *ca  = [[ClassicAudio alloc]init];
        ca.delegate=self;
        ca.url = self.UrlSource;
        [ca RefreshInfo];
    }
    else
    {
        [Tools DisplayNetworkAlert];
        [delegate AudioDataManagerDidReceivedNetWorkError];
    }
}
#pragma mark Delegates
-(void)ClassicAudioDidFailToLoadInfo:(NSError *)error{
    [self.delegate AudioDataManagerFailedToLoadInfo:error];
}
-(void)ClassicAudioDidLoadInfo:(NSMutableArray *)data{
    [self.delegate AudioDataManagerDidLoadInfo:data];
}
@end
