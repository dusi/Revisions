//
//  REItem.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REItem.h"

@implementation REItem

@synthesize title;
@synthesize link;
@synthesize info;
@synthesize date;

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
	[title release];
	[link release];
	[info release];
	[date release];
	
	[super dealloc];
}

@end
