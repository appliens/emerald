//
//  ClassicVideo.h
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ClassicVideoDelegate <NSObject>
-(void)ClassicVideoDidLoadInfo:(NSMutableArray *)data;
-(void)ClassicVideoDidFailToLoadInfo:(NSError *)error;
@optional
@end
@interface ClassicVideo : NSObject<NSXMLParserDelegate>{
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
