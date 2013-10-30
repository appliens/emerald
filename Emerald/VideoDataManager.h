//
//  VideoDataManager.h
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol VideoDataManagerDelegate <NSObject>
-(void)VideoDataManagerDidLoadInfo:(NSMutableArray *)data;
-(void)VideoDataManagerFailedToLoadInfo:(NSError *)error;
-(void)VideoDataManagerDidReceivedNetWorkError;
@optional
@end
#import <Foundation/Foundation.h>
#import "Youtube.h"
#import "Vimeo.h"
#import "ClassicVideo.h"
@interface VideoDataManager : NSObject <VimeoDelegate,YoutubeDelegate,ClassicVideoDelegate>{
    id delegate;
}
-(void)RefreshInfo;
@property(nonatomic , retain) id delegate;
@property (nonatomic,retain) NSString *UrlSource;
@end
