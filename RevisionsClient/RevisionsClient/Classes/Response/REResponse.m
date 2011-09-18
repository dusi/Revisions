//
//  REResponse.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REResponse.h"

@implementation REResponse

@synthesize characterBuffer;

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
		characterBuffer = nil;
    }
    return self;
}

- (void)dealloc
{
    [characterBuffer release];
	
    [super dealloc];
}

#pragma mark - Buffer

- (NSMutableString *)characterBuffer
{
	if (!characterBuffer)
		characterBuffer = [[NSMutableString alloc] init];
	
	return characterBuffer;
}

#pragma mark - LibXmlParserDelegate

- (void)parser:(LibXmlParser *)parser didStartElement:(const xmlChar *)localname attributes:(int)numberOfAttributes :(xmlSAX2Attributes *)attributes
{
    self.characterBuffer = nil;
}

- (void)parser:(LibXmlParser *)parser didEndElement:(const xmlChar *)localname { }

- (void)parser:(LibXmlParser *)parser didFoundCharacters:(const xmlChar *)ch length:(int)len
{
	NSString *value = [[NSString alloc] initWithBytes:(const void *)ch
											   length:len
											 encoding:NSUTF8StringEncoding];
    
	[self.characterBuffer appendString:value];
	[value release];
}

@end
