//
//  Flickr.h
//  MyNews
//
//  Created by ColtBoys on 04/04/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol FlickrDelegate <NSObject>
-(void)FlickrDidLoadInfo:(NSMutableArray *)data;
-(void)FlickrDidFailToLoadInfo:(NSError *)error;
@optional
@end
#import <Foundation/Foundation.h>
@interface Flickr : NSObject <NSXMLParserDelegate>{
    id delegate;
    NSXMLParser *rssParser;
    NSMutableArray *RssFeed;
    NSMutableDictionary * AnItem;
    //Data
    NSMutableString *title,*description,*link;
    NSString *element;
    BOOL top;
}
@property(nonatomic , retain) id delegate;
@property(nonatomic, retain) NSString *url;
-(void)RefreshInfo;
- (void)parseXMLFile;
-(void)CallDelegate;

@end
