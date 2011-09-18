//
//  NotificationDetailViewController.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NotificationDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
    UIActionSheet *deleteActionSheet;
    UIActionSheet *shareActionSheet;
}

@property (nonatomic, retain) UILocalNotification *localNotification;

- (IBAction)deleteNotification:(id)sender;
- (IBAction)share:(id)sender;

@end
