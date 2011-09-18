//
//  REItemsResponse.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REItemsResponse.h"
#import "REItem.h"

@implementation REItemsResponse

@synthesize revisions;

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        revisions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [revisions release];
    [currentItem release];
    [dateFormatter release];
    
    [super dealloc];
}

#pragma mark - Date formatter

- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    }
    return dateFormatter;
}

#pragma mark - Constants

static const char *kName_RevisionItem = "item";
static const NSUInteger kLength_RevisionItem = 5;

static const char *kName_Title = "title";
static const NSUInteger kLength_Title = 6;

static const char *kName_Link = "link";
static const NSUInteger kLength_Link = 5;

static const char *kName_Info = "description";
static const NSUInteger kLength_Info = 12;

static const char *kName_Date = "pubDate";
static const NSUInteger kLength_Date = 8;

#pragma mark - LibXmlParserDelegate

- (void)parser:(LibXmlParser *)parser didStartElement:(const xmlChar *)localname attributes:(int)numberOfAttributes :(xmlSAX2Attributes *)attributes
{
	[super parser:parser didStartElement:localname attributes: numberOfAttributes:attributes];
    
    if (strncmp((const char *)localname, kName_RevisionItem, kLength_RevisionItem) == 0)
    {
        currentItem = [[REItem alloc] init];
        
        return;
    }
}

- (void)parser:(LibXmlParser *)parser didEndElement:(const xmlChar *)localname
{
	[super parser:parser didEndElement:localname];
    
    if (strncmp((const char *)localname, kName_RevisionItem, kLength_RevisionItem) == 0)
    {
        [self.revisions addObject:currentItem];
        [currentItem release];
        currentItem = nil;
    }
    
    else if (strncmp((const char *)localname, kName_Title, kLength_Title) == 0)
    {
        NSRange range = [self.characterBuffer rangeOfString:@" - "];
        NSRange newRange;
        
        if (range.location == NSNotFound)
        {
            newRange = NSMakeRange(0, [self.characterBuffer length]);
        }
        else
        {
            NSUInteger rangeOffset = range.location + range.length;
            newRange = NSMakeRange(rangeOffset, [self.characterBuffer length] - rangeOffset);
        }
        
        currentItem.title = [self.characterBuffer substringWithRange:newRange];
    }
    
    else if (strncmp((const char *)localname, kName_Link, kLength_Link) == 0)
    {
        currentItem.link = self.characterBuffer;
    }
    
    else if (strncmp((const char *)localname, kName_Info, kLength_Info) == 0)
    {
        currentItem.info = self.characterBuffer;
    }
    
    else if (strncmp((const char *)localname, kName_Date, kLength_Date) == 0)
    {
        NSDate *date = [self.dateFormatter dateFromString:self.characterBuffer];
        currentItem.date = date;
    }
    
    self.characterBuffer = nil;
}

@end
