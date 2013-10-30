//
//  ClassicPicture.h
//  Emerald
//
//  Created by ColtBoys on 1/2/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//
@protocol ClassicPictureDelegate <NSObject>
-(void)ClassicPictureDidLoadInfo:(NSMutableArray *)data;
-(void)ClassicPictureDidFailToLoadInfo:(NSError *)error;
@optional
@end
#import <Foundation/Foundation.h>

@interface ClassicPicture : NSObject <NSXMLParserDelegate>{
    NSXMLParser *rssParser;
    NSMutableArray *RssFeed;
    NSMutableDictionary * AnItem;
    //Data
    NSMutableString *title,*description,*link,*thumb;
    NSString *element;
    id delegate;
}
@property(nonatomic , retain) id delegate;
@property(nonatomic, retain) NSString *url;
-(void)RefreshInfo;
- (void)parseXMLFile;
-(void)CallDelegate;
@end
