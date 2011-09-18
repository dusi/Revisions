//
//  LibXmlParser.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LibXmlParser.h"
#import <libxml/parser.h>

@implementation LibXmlParser

@synthesize delegate;
@synthesize success;

static xmlSAXHandler simpleSAXHandlerStruct;

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
	if (self)
    {
        parserContext = xmlCreatePushParserCtxt(&simpleSAXHandlerStruct, self, NULL, 0, NULL);
        
		success = YES;
	}
	return self;
}

- (void)dealloc
{
	xmlFreeParserCtxt(parserContext);
	
	[super dealloc];
}

#pragma mark - XML parsing interface

- (void)parseChunk:(NSData *)data
{
	if (self.success)
		xmlParseChunk(parserContext, (const char *)[data bytes], [data length], 0);
}

- (void)parsingCompleted
{
	if (self.success)
		xmlParseChunk(parserContext, NULL, 0, 1);
}

#pragma mark - Delegation

- (void)didStartElement:(const xmlChar *)localname attributes:(int)numberOfAttributes :(xmlSAX2Attributes *)attributes
{
    [self.delegate parser:self didStartElement:localname attributes:numberOfAttributes :attributes];
}

- (void)didEndElement:(const xmlChar *)localname
{
	[self.delegate parser:self didEndElement:localname];
}

- (void)didFoundCharacters:(const xmlChar *)ch length:(int)len
{
	[self.delegate parser:self didFoundCharacters:ch length:len];
}

#pragma mark - libxml2 SAX parser callback methods

static void startElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI, int nb_namespaces, const xmlChar **namespaces, int nb_attributes, int nb_defaulted, const xmlChar **attributes)
{
	LibXmlParser *context = (LibXmlParser *)ctx;
	
	[context didStartElement:localname attributes:nb_attributes :(xmlSAX2Attributes *)attributes];
}

static void	endElementSAX(void *ctx, const xmlChar *localname, const xmlChar *prefix, const xmlChar *URI)
{
	LibXmlParser *context = (LibXmlParser *)ctx;
	
	[context didEndElement:localname];
}

static void	charactersFoundSAX(void *ctx, const xmlChar *ch, int len)
{
	LibXmlParser *context = (LibXmlParser *)ctx;
	
	[context didFoundCharacters:ch length:len];
}

static void errorEncounteredSAX(void *ctx, const char *msg, ...)
{
    LibXmlParser *context = (LibXmlParser *)ctx;
	
	context.success = NO;
}

#pragma mark - SAX struct

static xmlSAXHandler simpleSAXHandlerStruct = {
	NULL,                       /* internalSubset */
	NULL,                       /* isStandalone   */
	NULL,                       /* hasInternalSubset */
	NULL,                       /* hasExternalSubset */
	NULL,                       /* resolveEntity */
	NULL,                       /* getEntity */
	NULL,                       /* entityDecl */
	NULL,                       /* notationDecl */
	NULL,                       /* attributeDecl */
	NULL,                       /* elementDecl */
	NULL,                       /* unparsedEntityDecl */
	NULL,                       /* setDocumentLocator */
	NULL,                       /* startDocument */
	NULL,                       /* endDocument */
	NULL,                       /* startElement*/
	NULL,                       /* endElement */
	NULL,                       /* reference */
	charactersFoundSAX,         /* characters */
	NULL,                       /* ignorableWhitespace */
	NULL,                       /* processingInstruction */
	NULL,                       /* comment */
	NULL,                       /* warning */
	errorEncounteredSAX,        /* error */
	NULL,                       /* fatalError //: unused error() get all the errors */
	NULL,                       /* getParameterEntity */
	NULL,                       /* cdataBlock */
	NULL,                       /* externalSubset */
	XML_SAX2_MAGIC,             //
	NULL,
	startElementSAX,            /* startElementNs */
	endElementSAX,              /* endElementNs */
	NULL,                       /* serror */
};

@end
