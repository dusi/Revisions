//
//  REItemsRequest.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REItemsRequest.h"
#import "REConstants.h"
#import "REItemsResponse.h"

@implementation REItemsRequest

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Abstract accessors implementation

- (REResponse *)newResponse
{
	return [[REItemsResponse alloc] init];
}


- (NSString *)action
{
	return [NSString stringWithFormat:@"%@", REBaseURL];
}

@end
