//
//  RevisionsViewController.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RERequest.h"

@class PlaceholderView;

@interface RevisionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RERequestDelegate>
{
    RERequest *currentRequest;
    
    NSMutableArray *revisions;
    
    BOOL hasLoaded;
    
    IBOutlet UITableView *tableView;
    IBOutlet PlaceholderView *placeholderView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

@end
