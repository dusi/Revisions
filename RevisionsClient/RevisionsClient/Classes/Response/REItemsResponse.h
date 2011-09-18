//
//  REItemsResponse.h
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REResponse.h"
#import "LibXmlParser.h"

@class REItem;

@interface REItemsResponse : REResponse <LibXmlParserDelegate>
{
	REItem *currentItem;
    
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, readonly) NSMutableArray *revisions;

@end
