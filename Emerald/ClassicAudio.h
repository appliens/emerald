//
//  ClassicAudio.h
//  Emerald
//
//  Created by ColtBoys on 1/20/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ClassicAudioDelegate <NSObject>
-(void)ClassicAudioDidLoadInfo:(NSMutableArray *)data;
-(void)ClassicAudioDidFailToLoadInfo:(NSError *)error;
@optional
@end
@interface ClassicAudio : NSObject <NSXMLParserDelegate>{
    NSXMLParser *rssParser;
    NSMutableArray *RssFeed;
    NSMutableDictionary * AnItem;
    //Data
    NSMutableString *title,*source,*link,*thumb,*price,*buyLink,*heightCell,*urlSource;
    NSString *element;
    id delegate;
}
@property(nonatomic , retain) id delegate;
@property(nonatomic, retain) NSString *url;
-(void)RefreshInfo;
- (void)parseXMLFile;
-(void)CallDelegate;
@end
