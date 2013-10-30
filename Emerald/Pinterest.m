//
//  Pinterest.m
//  KrisSorbie
//
//  Created by ColtBoys on 14/03/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "Pinterest.h"

@implementation Pinterest
@synthesize delegate;
@synthesize url;
-(void)LoadData{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]
                                 initWithTarget:self
                                 selector:@selector(parseXMLFile)
                                 object:nil];
    [queue addOperation:op];
    
}
-(void)parseXMLFile
{	
    //Url
    NSURL *xmlURL = [NSURL URLWithString:self.url];
    
    //Init
    if (rssParser!=nil) {
        rssParser =nil;
        [RssFeed removeAllObjects];
        RssFeed=nil;
    }

    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [rssParser setDelegate:self];
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	RssFeed = [[NSMutableArray alloc] init];
    [rssParser parse];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[delegate PinterestDidFailToLoadInfo:parseError];
    NSLog(@"error : %@",parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
	element =elementName;
	if ([elementName isEqualToString:@"item"]) {
		[AnItem removeAllObjects];
        AnItem=nil;
        title=nil;
        link=nil;
        description=nil;
        
		AnItem = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];;
		link = [[NSMutableString alloc] init];
		description = [[NSMutableString alloc] init];
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	
	if ([elementName isEqualToString:@"item"]) {
		
		[AnItem setObject:title forKey:@"title"];
		[AnItem setObject:link forKey:@"link"];
        if ([description componentsSeparatedByString:@"upload/"].count>1) {
            description = [NSString stringWithFormat:@"http://media-cdn3.pinterest.com/upload/%@",[[[[description componentsSeparatedByString:@"upload/"]objectAtIndex:1]componentsSeparatedByString:@"\">"]objectAtIndex:0]];
            [AnItem setObject:[[self flattenHTML:description]stringByReplacingOccurrencesOfString:@"_b.jpg" withString:@"_c.jpg"] forKey:@"image"];
            [AnItem setObject:[[self flattenHTML:description]stringByReplacingOccurrencesOfString:@"_b.jpg" withString:@"_c.jpg"] forKey:@"thumb"];

        }
        else
        {
            if ([description componentsSeparatedByString:@"<img src=\""].count>1) {
                description=[[description componentsSeparatedByString:@"<img src=\""]objectAtIndex:1];
                description = [[description componentsSeparatedByString:@"\">"]objectAtIndex:0];
            }
            else
            {
                [description setString:@""];
            }
            
            [AnItem setObject:description forKey:@"image"];
            [AnItem setObject:description forKey:@"thumb"];

        }
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
	} else if ([element isEqualToString:@"link"]) {
		[link appendString:string];
	} else if ([element isEqualToString:@"description"]) {
		[description appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self performSelectorOnMainThread:@selector(CallDelegate) withObject:nil waitUntilDone:false];
}
-(void)CallDelegate{
    [delegate PinterestDidLoadInfo:RssFeed];
}

@end
