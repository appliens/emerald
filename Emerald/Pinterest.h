//
//  Pinterest.h
//  KrisSorbie
//
//  Created by ColtBoys on 14/03/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PinterestDelegate <NSObject>
@required
-(void)PinterestDidLoadInfo:(NSMutableArray *)data;
@optional
-(void)PinterestDidFailToLoadInfo:(NSError *)error;
@end

@interface Pinterest : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *rssParser;
    NSMutableArray *RssFeed;
    NSMutableDictionary * AnItem;
    //Data
    NSMutableString *title,*description,*link;
    NSString *element;
    id delegate;

}
@property (nonatomic,retain) id delegate;
@property (nonatomic,retain) NSString *url;
-(void)LoadData;
- (NSString *)flattenHTML:(NSString *)html;
-(void)CallDelegate;

@end
