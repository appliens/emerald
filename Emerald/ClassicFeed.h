//
//  ClassicFeed.h
//  Emerald
//
//  Created by ColtBoys on 12/26/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol ClassicFeedDelegate <NSObject>
-(void)ClassicFeedDidLoadInfo:(NSMutableArray *)data;
-(void)ClassicFeedFailedToLoadInfo:(NSError *)error;
-(void)ClassicFeedDidReceivedNetWorkError;
@optional
@end
#import <Foundation/Foundation.h>
#import "Config.h"
@interface ClassicFeed : NSObject<NSXMLParserDelegate>{
    id delegate;
    NSXMLParser *rssParser;
    NSMutableArray *RssFeed;
    NSMutableDictionary * AnItem;
    //Data
    NSMutableString *title,*description,*pubDate,*link,*image;
    NSString *element;
    NSString *urlWP;
    
}
@property(nonatomic , retain) id delegate;
@property (nonatomic,retain) NSString *XMLSource;
-(void)RefreshInfo;
- (void)parseXMLFile;
- (NSString *)flattenHTML:(NSString *)html;
-(void)CallDelegate;
@end