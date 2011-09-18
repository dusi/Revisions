//
//  LibXmlParser.h
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>

typedef struct tagXmlSAX2Attributes {
	const xmlChar *localname;
	const xmlChar *prefix;
	const xmlChar *uri;
	const xmlChar *value;
	const xmlChar *end;
} xmlSAX2Attributes;

@class LibXmlParser;

@protocol LibXmlParserDelegate <NSObject>
@optional
- (void)parser:(LibXmlParser *)parser didStartElement:(const xmlChar *)localname attributes:(int)numberOfAttributes :(xmlSAX2Attributes *)attributes;
- (void)parser:(LibXmlParser *)parser didEndElement:(const xmlChar *)localname;
- (void)parser:(LibXmlParser *)parser didFoundCharacters:(const xmlChar *)ch length:(int)len;
@end

@interface LibXmlParser : NSObject
{
    xmlParserCtxtPtr parserContext;
}

@property (nonatomic, assign) id <LibXmlParserDelegate> delegate;
@property (nonatomic, readwrite) BOOL success;

- (void)parseChunk:(NSData *)data;
- (void)parsingCompleted;

- (void)didStartElement:(const xmlChar *)localname attributes:(int)numberOfAttributes :(xmlSAX2Attributes *)attributes;
- (void)didEndElement:(const xmlChar *)localname;
- (void)didFoundCharacters:(const xmlChar *)ch length:(int)len;

@end
