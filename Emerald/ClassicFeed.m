//
//  ClassicFeed.m
//  Emerald
//
//  Created by ColtBoys on 12/26/12.
//  Copyright (c) 2013 coltboy. All rights reserved.
//

#import "ClassicFeed.h"
#import "Tools.h"
@implementation ClassicFeed
@synthesize delegate;
@synthesize XMLSource;
-(void)RefreshInfo{
    if ([Tools isNetWorkConnectionAvailable]) {
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *op = [[NSInvocationOperation alloc]
                                     initWithTarget:self
                                     selector:@selector(parseXMLFile)
                                     object:nil];
        [queue addOperation:op];
    }
    else
    {
        [Tools DisplayNetworkAlert];
        [delegate ClassicFeedDidReceivedNetWorkError];
    }
}
- (void)parseXMLFile
{
    
	RssFeed = [[NSMutableArray alloc] init];
	
	
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:self.XMLSource]];
	
    
    [rssParser setDelegate:self];
	
    
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[delegate ClassicFeedFailedToLoadInfo:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	element =elementName;
	if ([elementName isEqualToString:@"item"]) {
		
		AnItem = [[NSMutableDictionary alloc] init];
		title = [[NSMutableString alloc] init];
		pubDate = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
		link = [[NSMutableString alloc]init];
        image = [[NSMutableString alloc]init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	if ([elementName isEqualToString:@"item"]) {
		[AnItem setObject:[self flattenHTML:title] forKey:@"title"];
		[AnItem setObject:description forKey:@"description"];
        [AnItem setObject:[[pubDate componentsSeparatedByString:@"+"]objectAtIndex:0] forKey:@"date"];
        [AnItem setObject:link forKey:@"link"];
        if (image.length==0) {
            [AnItem setObject:[self findAnImage] forKey:@"image"];
            [AnItem setObject:@"nocover" forKey:@"cover-not-active"];
        }
        else
        {
           [AnItem setObject:image forKey:@"image"];
        }
        if ([self flattenHTML:description].length>200) {
            [AnItem setObject:[[self flattenHTML:description]substringToIndex:200] forKey:@"description-nohtml"];
        }
        else
        {
            [AnItem setObject:[self flattenHTML:description] forKey:@"description-nohtml"];
        }
        
        
		[RssFeed addObject:[AnItem copy]];
		
	}
	
}
-(NSString *)findAnImage{
    NSString *result;
    if (![self stringContainsImage:description]) {
        result=@"";
    }
    else
    {
        result=@"";
        if ([description componentsSeparatedByString:@"<img src="].count >=2) {
            if ([[[description componentsSeparatedByString:@"<img src="]objectAtIndex:1]componentsSeparatedByString:@"\""].count >=2) {
                result = [[[[description componentsSeparatedByString:@"<img src="]objectAtIndex:1]componentsSeparatedByString:@"\""]objectAtIndex:1];
            }
            
        }
    }
    return result;
}
-(BOOL)stringContainsImage:(NSString *)string{
    BOOL result =YES;
    if ([string rangeOfString:@".jpg"].location == NSNotFound) {
        if ([string rangeOfString:@".png"].location == NSNotFound) {
            if ([string rangeOfString:@".gif"].location == NSNotFound) {
                if ([string rangeOfString:@".PNG"].location == NSNotFound) {
                    if ([string rangeOfString:@".JPG"].location == NSNotFound) {
                        if ([string rangeOfString:@".GIF"].location == NSNotFound) {
                            if ([string rangeOfString:@".jpeg"].location == NSNotFound) {
                                if ([string rangeOfString:@".JPEG"].location == NSNotFound) {
                                    result=NO;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return result;
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
    html = [html stringByReplacingOccurrencesOfString:@"&#160;" withString:@"  "];
    html = [html stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"’"];
    html = [html stringByReplacingOccurrencesOfString:@"\\U2019" withString:@""];
    
	// Trimmed return
	
	return [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if ([element isEqualToString:@"title"]) {
		[title appendString:string];
	} else if ([element isEqualToString:@"description"]) {
		[description appendString:string];
	} else if ([element isEqualToString:@"pubDate"]) {
		[pubDate appendString:string];
	} else if ([element isEqualToString:@"link"]) {
		[link appendString:string];
	} else if ([element isEqualToString:@"image"]){
        [image appendString:string];
    }
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self performSelectorOnMainThread:@selector(CallDelegate) withObject:nil waitUntilDone:false];
}
-(void)CallDelegate{
    [delegate ClassicFeedDidLoadInfo:RssFeed];
}

@end
