//
//  NetworkActivityController.h
//  RevisionsClient
//
//  Created by Dušátko Pavel on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkActivityController : NSObject
{
    NSInteger level;
}

+ (NetworkActivityController *)sharedController;

- (void)startNewNetworkActivity;
- (void)stopNetworkActivity;

@end
