//
//  Vimeo.m
//  MyNews
//
//  Created by ColtBoys on 04/04/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "Vimeo.h"

@implementation Vimeo
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
	[delegate VimeoDidFailToLoadInfo:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
	element =elementName;
	if ([elementName isEqualToString:@"video"]) {
		AnItem = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc] init];
        embed = [[NSMutableString alloc] init];
		thumb = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	
	if ([elementName isEqualToString:@"video"]) {
		[AnItem setObject:title forKey:@"title"];
		[AnItem setObject:embed forKey:@"embed"];
        [AnItem setObject:link forKey:@"link"];
        [AnItem setObject:thumb forKey:@"thumb"];
        [AnItem setObject:@"vimeo" forKey:@"type"];
		[RssFeed addObject:[AnItem copy]];
		
	}
	
}
- (NSString *)flattenHTML:(NSString *)html {
	
	NSScanner *thescanner;
	
	NSString *text = nil;
	
	thescanner = [NSScanner scannerWithString:html];
	
	while ([thescanner isAtEnd] == NO) {
		
		// find start of tag
		
		[thescanner scanUpToString:@"<" intoString:nil];
		
		// find end of tag
		
		[thescanner scanUpToString:@">" intoString:&text];
		
		// replace the found tag with a space
		
		//(you can filter multi-spaces out later if you wish)
		
		html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
		
	}
	
	html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@"\n"];
	html = [html stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
	html = [html stringByReplacingOccurrencesOfString:@"&bull;" withString:@" * "];
	html = [html stringByReplacingOccurrencesOfString:@"&lsaquo;" withString:@"<"];
	html = [html stringByReplacingOccurrencesOfString:@"&rsaquo;" withString:@">"];
	html = [html stringByReplacingOccurrencesOfString:@"&trade;" withString:@"(tm)"];
	html = [html stringByReplacingOccurrencesOfString:@"&frasl;" withString:@"/"];
	html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
	html = [html stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
	html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
	html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
	html = [html stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
	html = [html stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
	// Trimmed return
	
	return [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([element isEqualToString:@"title"]) {
		[title appendString:string];
	} else if ([element isEqualToString:@"id"]) {
		[embed appendString:string];
	} else if ([element isEqualToString:@"thumbnail_large"]) {
		[thumb appendString:string];
	} else if ([element isEqualToString:@"url"]) {
		[link appendString:string];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self performSelectorOnMainThread:@selector(CallDelegate) withObject:nil waitUntilDone:false];
}
-(void)CallDelegate{
    [delegate VimeoDidLoadInfo:RssFeed];
}

@end
