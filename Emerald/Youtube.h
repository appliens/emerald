//
//  Youtube.h
//  MyNews
//
//  Created by ColtBoys on 04/04/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol YoutubeDelegate <NSObject>
-(void)YoutubeDidLoadInfo:(NSMutableArray *)data;
-(void)YoutubeDidFailToLoadInfo:(NSError *)error;
@optional
@end

#import <Foundation/Foundation.h>
@interface Youtube : NSObject <NSXMLParserDelegate>{
    id delegate;
    NSXMLParser *rssParser;
    NSMutableArray *RssFeed;
    NSMutableDictionary * AnItem;
    //Data
    NSMutableString *title,*embed,*link,*thumb;
    NSString *element;
    BOOL top;
}
@property(nonatomic , retain) id delegate;
@property(nonatomic, retain) NSString *url;
-(void)RefreshInfo;
- (void)parseXMLFile;
- (NSString *)flattenHTML:(NSString *)html;
-(void)CallDelegate;
@end
