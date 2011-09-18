//
//  REResponse.h
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibXmlParser.h"

@interface REResponse : NSObject <LibXmlParserDelegate>

@property (nonatomic, retain) NSMutableString *characterBuffer;

@end
