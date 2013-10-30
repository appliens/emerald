//
//  AudioDataManager.h
//  Emerald
//
//  Created by ColtBoys on 1/20/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol AudioDataManagerDelegate <NSObject>
-(void)AudioDataManagerDidLoadInfo:(NSMutableArray *)data;
-(void)AudioDataManagerFailedToLoadInfo:(NSError *)error;
-(void)AudioDataManagerDidReceivedNetWorkError;
@optional
@end
#import <Foundation/Foundation.h>
#import "ClassicAudio.h"
@interface AudioDataManager : NSObject<ClassicAudioDelegate>{
    id delegate;
}
-(void)RefreshInfo;
@property(nonatomic , retain) id delegate;
@property (nonatomic,retain) NSString *UrlSource;
@end
