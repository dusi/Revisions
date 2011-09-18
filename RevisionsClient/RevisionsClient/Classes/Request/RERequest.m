//
//  RERequest.m
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RERequest.h"
#import "REConstants.h"
#import "NetworkActivityController.h"

NSInteger  const REInvalidResponse = 1000;
NSInteger  const REStatusCode = 1001;
NSString * const REErrorDomain = @"REErrorDomain";
NSString * const RERequestDidStartLoadingNotification = @"RERequestDidStartLoadingNotification";
NSString * const RERequestDidFinishLoadingNotification = @"RERequestDidFinishLoadingNotification";

@interface RERequest ()
- (NSURL *)url;
- (NSURLRequest *)request;
@end

@implementation RERequest

@synthesize delegate;

#pragma mark - Object lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        isRunning = YES;
    }
    return self;
}

- (void)dealloc
{
    [response release];
    [parser release];
    
    [super dealloc];
}

#pragma mark - NSOperation

- (void)main
{
    if (!self.isCancelled)
    {
        currentConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RERequestDidStartLoadingNotification object:self];
        
        [[NetworkActivityController sharedController] startNewNetworkActivity];
        
        do
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                     beforeDate:[NSDate distantFuture]];
        }
        while (isRunning);
        
        if (!self.isCancelled)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:RERequestDidFinishLoadingNotification object:self];
            
            [[NetworkActivityController sharedController] stopNetworkActivity];
        }
        
        [currentConnection release];
        currentConnection = nil;
    }
}

- (void)runLoop
{
	isRunning = YES;
	
	do
    {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	while (isRunning && !self.isCancelled);
}

- (void)cancel
{
    [super cancel];
    
    if (currentConnection)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RERequestDidFinishLoadingNotification object:self];
        
        [[NetworkActivityController sharedController] stopNetworkActivity];
        
        [currentConnection cancel];
    }
    
    isRunning = NO;
}

#pragma mark - Abstract accessors

- (REResponse <LibXmlParserDelegate> *)newResponse
{
	[NSException raise:NSInternalInconsistencyException 
                format:@"%@ must be overriden in a subclass", NSStringFromSelector(_cmd)];
	
	return nil;
}

- (NSString *)requestAction
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"%@ must be overriden in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

- (NSDictionary *)requestParams
{
	[NSException raise:NSInternalInconsistencyException 
				format:@"%@ must be overriden in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

#pragma mark - Private interface

#define TIMEOUT_INTERVAL 30.0

- (NSURL *)url
{
    // Example: https://old.uhk.cz/rss/?c=fim-zmeny-rozvrh
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@", REBaseURL]];
}

- (NSURLRequest *)request
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:TIMEOUT_INTERVAL];
    return request;
}

#pragma mark - Delegation

- (void)didFinishWithResponse:(REResponse *)aResponse
{
    if (self.isCancelled)
        return;
    
	if ([NSThread isMainThread])
    {
		if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFinishWithResponse:)])
			[self.delegate request:self didFinishWithResponse:aResponse];
	}
	else
    {
		[self performSelectorOnMainThread:@selector(didFinishWithResponse:)
							   withObject:aResponse
							waitUntilDone:NO];
	}
}

- (void)didFailWithError:(NSError *)error
{
    if (self.isCancelled)
        return;
    
	if ([NSThread isMainThread])
    {
		if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)])
			[self.delegate request:self didFailWithError:error];
	}
	else
    {
		[self performSelectorOnMainThread:@selector(didFailWithError:) 
							   withObject:error
							waitUntilDone:NO];
	}
}

#pragma mark - NSURLConnection

#define HTTP_OK_CODE 200.0

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse
{
    [response release]; response = nil;
    [parser release]; parser = nil;
    
    NSInteger aStatusCode = [((NSHTTPURLResponse *)urlResponse) statusCode];
    
    if (aStatusCode == HTTP_OK_CODE)
    {
        response = [self newResponse];
        
        parser = [[LibXmlParser alloc] init];
        parser.delegate = response;
    }
    else
    {
        statusCode = [[NSNumber alloc] initWithInteger:aStatusCode];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[parser parseChunk:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)aError
{
	isRunning = NO;
    
    [self didFailWithError:aError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	isRunning = NO;
	
	[parser parsingCompleted];
    
    if (parser)
    {
        if (parser.success)
        {
            if (response)
            {
                [self didFinishWithResponse:response];
            }
            else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:statusCode forKey:@"statusCode"];
                NSError *error = [NSError errorWithDomain:REErrorDomain code:REStatusCode userInfo:userInfo];
                
                [self didFailWithError:error];
            }
        }
    }
}

@end
