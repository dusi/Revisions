//
//  NetworkActivityController.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkActivityController.h"

@implementation NetworkActivityController

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
	if (self)
    {
		level = 0;
	}
	return self;
}

+ (NetworkActivityController *)sharedController
{
	static NetworkActivityController *sharedController;
	
	@synchronized(self)
    {
		if (!sharedController)
			sharedController = [[NetworkActivityController alloc] init];
	}
	return sharedController;
}

#pragma mark - Activity manager

- (void)refreshNetworkActivityIndicator
{
	if ([NSThread isMainThread])
    {
		BOOL visible = level > 0;
		
		if ([UIApplication sharedApplication].networkActivityIndicatorVisible != visible)
			[UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
	}
	else
    {
		[self performSelectorOnMainThread:@selector(refreshNetworkActivityIndicator)
							   withObject:nil
							waitUntilDone:NO];
	}
}

- (void)startNewNetworkActivity
{
	level++;
	
	[self refreshNetworkActivityIndicator];
}

- (void)stopNetworkActivity
{
	level--;
	
	[self refreshNetworkActivityIndicator];
}

@end
