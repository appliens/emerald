//
//  PhotoDataManager.h
//  Emerald
//
//  Created by ColtBoys on 1/2/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol PhotoDataManagerDelegate <NSObject>
-(void)PhotoDataManagerDidLoadInfo:(NSMutableArray *)data;
-(void)PhotoDataManagerFailedToLoadInfo:(NSError *)error;
-(void)PhotoDataManagerDidReceivedNetWorkError;
@optional
@end
#import <Foundation/Foundation.h>
#import "Flickr.h"
#import "Pinterest.h"
#import "ClassicPicture.h"
@interface PhotoDataManager : NSObject <FlickrDelegate,PinterestDelegate,ClassicPictureDelegate>{
    id delegate;
    
}
-(void)RefreshInfo;
@property(nonatomic , retain) id delegate;
@property (nonatomic,retain) NSString *UrlSource;
@end
