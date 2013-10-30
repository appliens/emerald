//
//  ClassicAudio.m
//  Emerald
//
//  Created by ColtBoys on 1/20/13.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "ClassicAudio.h"

@implementation ClassicAudio
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
	[delegate ClassicAudioDidFailToLoadInfo:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	element =elementName;
	if ([elementName isEqualToString:@"item"]) {
		AnItem = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc] init];
        price = [[NSMutableString alloc] init];
        buyLink = [[NSMutableString alloc] init];
        heightCell = [[NSMutableString alloc] init];
		thumb = [[NSMutableString alloc] init];
        urlSource = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"item"]) {
		[AnItem setObject:title forKey:@"title"];
        [AnItem setObject:price forKey:@"price"];
        [AnItem setObject:buyLink forKey:@"buyLink"];
        [AnItem setObject:heightCell forKey:@"height"];
        [AnItem setObject:link forKey:@"link"];
        [AnItem setObject:thumb forKey:@"thumb"];
        [AnItem setObject:urlSource forKey:@"urlSource"];
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
	} else if ([element isEqualToString:@"price"]) {
        [price appendString:string];
    } else if ([element isEqualToString:@"buyLink"]) {
        [buyLink appendString:string];
    } else if ([element isEqualToString:@"imgHeight"]) {
        [heightCell appendString:string];
    } else if ([element isEqualToString:@"urlSource"]) {
        [urlSource appendString:string];
    }
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self performSelectorOnMainThread:@selector(CallDelegate) withObject:nil waitUntilDone:false];
}
-(void)CallDelegate{
    [delegate ClassicAudioDidLoadInfo:RssFeed];
}

@end
