//
//  RevisionDetailViewController.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class REItem;

@interface RevisionDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIBarButtonItem *favoriteBarButtonItem;
    IBOutlet UIBarButtonItem *notifBarButtonItem;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIDatePicker *datePicker;
    
    UIActionSheet *notifActionSheet;
    UIActionSheet *shareActionSheet;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) REItem *revision;

- (IBAction)addToFavorites:(id)sender;
- (IBAction)addNotification:(id)sender;
- (IBAction)share:(id)sender;

@end
