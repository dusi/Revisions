//
//  RERequest.h
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibXmlParser.h"
#import "REResponse.h"

extern NSInteger  const REInvalidResponse;
extern NSInteger  const REStatusCode;
extern NSString * const REErrorDomain;
extern NSString * const RERequestDidStartLoadingNotification;
extern NSString * const RERequestDidFinishLoadingNotification;

@class RERequest;

@protocol RERequestDelegate <NSObject>
- (void)request:(RERequest *)request didFinishWithResponse:(REResponse *)response;
- (void)request:(RERequest *)request didFailWithError:(NSError *)error;
@end

@interface RERequest : NSOperation
{
    REResponse <LibXmlParserDelegate> *response;
    
    LibXmlParser *parser;
    
    NSNumber *statusCode;
    
	BOOL isRunning;
    
    NSURLConnection *currentConnection;
}

@property (nonatomic, assign) id <RERequestDelegate> delegate;

- (void)didFinishWithResponse:(REResponse *)response;
- (void)didFailWithError:(NSError *)error;

- (REResponse <LibXmlParserDelegate> *)newResponse;
- (NSString *)requestAction;
- (NSDictionary *)requestParams;

@end
