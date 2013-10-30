//
//  ClassicVideo.m
//  Emerald
//
//  Created by ColtBoys on 1/13/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "ClassicVideo.h"

@implementation ClassicVideo
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
	[delegate ClassicVideoDidFailToLoadInfo:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	element =elementName;
	if ([elementName isEqualToString:@"item"]) {
		
		AnItem = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
		thumb = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"]) {
		
		[AnItem setObject:title forKey:@"title"];
		[AnItem setObject:description forKey:@"embed"];
        [AnItem setObject:link forKey:@"link"];
        [AnItem setObject:thumb forKey:@"thumb"];
        [AnItem setObject:@"classic" forKey:@"type"];
		[RssFeed addObject:[AnItem copy]];
		
	}
	
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([element isEqualToString:@"title"]) {
		[title appendString:string];
	} else if ([element isEqualToString:@"thumb"]) {
		[thumb appendString:string];
	} else if ([element isEqualToString:@"link"]) {
		[link appendString:string];
	} else if ([element isEqualToString:@"embed"]) {
        [description appendString:string];
    }
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self performSelectorOnMainThread:@selector(CallDelegate) withObject:nil waitUntilDone:false];
}
-(void)CallDelegate{
    [delegate ClassicVideoDidLoadInfo:RssFeed];
}

@end
