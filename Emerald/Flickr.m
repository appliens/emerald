//
//  Flickr.m
//  MyNews
//
//  Created by ColtBoys on 04/04/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "Flickr.h"

@implementation Flickr
@synthesize delegate;
@synthesize url;
-(void)RefreshInfo{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]
                                 initWithTarget:self
                                 selector:@selector(parseXMLFile)
                                 object:nil];
    [queue addOperation:op];
    
}
- (void)parseXMLFile
{	
    
	RssFeed = [[NSMutableArray alloc] init];
	
    
    NSURL *xmlURL = [NSURL URLWithString:self.url];
	
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    
    [rssParser setDelegate:self];
	
    
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[delegate FlickrDidFailToLoadInfo:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
	element =elementName;
	if ([elementName isEqualToString:@"item"]) {
		
		AnItem = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	
	if ([elementName isEqualToString:@"item"]) {
		
		[AnItem setObject:title forKey:@"title"];
        NSString *imglink= [[[[description componentsSeparatedByString:@"<img src="] objectAtIndex:1]componentsSeparatedByString:@"</a>"]objectAtIndex:0];
        imglink = [[imglink componentsSeparatedByString:@"\""]objectAtIndex:1];
        imglink = [imglink stringByReplacingOccurrencesOfString:@"_m" withString:@"_b"];
		[AnItem setObject:imglink forKey:@"image"];
        [AnItem setObject:imglink forKey:@"thumb"];
        [AnItem setObject:link forKey:@"link"];
		[RssFeed addObject:[AnItem copy]];
		
	}
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([element isEqualToString:@"title"]) {
		[title appendString:string];
	} else if ([element isEqualToString:@"description"]) {
		[description appendString:string];
	} else if ([element isEqualToString:@"link"]) {
		[link appendString:string];
	} 
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self performSelectorOnMainThread:@selector(CallDelegate) withObject:nil waitUntilDone:false];
}
-(void)CallDelegate{
    [delegate FlickrDidLoadInfo:RssFeed];
}

@end
