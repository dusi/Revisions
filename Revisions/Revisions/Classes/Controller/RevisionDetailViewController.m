//
//  RevisionDetailViewController.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RevisionDetailViewController.h"
#import "REItem.h"
#import "Favorite.h"
#import "DescriptionTableViewCell.h"

@interface RevisionDetailViewController ()
- (NSDateFormatter *)dateFormatter;
- (BOOL)isFavorite:(REItem *)aRevision;
- (BOOL)hasNotification:(REItem *)aRevision;
- (NSDate *)dateToNext5Minutes:(NSDate *)aDate;
@end

@implementation RevisionDetailViewController

@synthesize managedObjectContext;
@synthesize revision;

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadData)
                                                     name:@"LocalNotificationRefreshNotifications"
                                                   object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [managedObjectContext release];
    [revision release];
    [tableView release];
    [favoriteBarButtonItem release];
    [notifBarButtonItem release];
    [toolbar release];
    [datePicker release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)reloadData
{
    favoriteBarButtonItem.enabled = ![self isFavorite:self.revision];
    notifBarButtonItem.enabled = ![self hasNotification:self.revision];
}

- (CGFloat)heightForDescription:(NSString *)description
{
	CGFloat width = self.view.frame.size.width;
	
	CGSize constraint = CGSizeMake(width, NSIntegerMax);
	CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:16.0]
                          constrainedToSize:constraint];
    
	CGFloat height = MAX(20.0, size.height);
    
    return height + 80.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.revision.title;
    
    datePicker.calendar = [NSCalendar currentCalendar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView standardCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    
	UITableViewCell *cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = NSLocalizedString(@"Date", nil);
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.revision.date];
    
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView descriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DescriptionCell";
    
	DescriptionTableViewCell *cell = (DescriptionTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[DescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = NSLocalizedString(@"Description", nil);
    cell.detailTextLabel.text = self.revision.info;
    
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return [self tableView:aTableView standardCellAtIndexPath:indexPath];
        }
        case 1:
        {
            return [self tableView:aTableView descriptionCellAtIndexPath:indexPath];
        }
    }
    
    return nil;
}

#pragma mark - Table view delegation

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
        return [self heightForDescription:revision.info];
    
    return 60.0;
}

#pragma mark - Favorites

- (Favorite *)favoriteWithTitle:(NSString *)title
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"title LIKE %@", title]];
	
	NSError *error;
	NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
	[request release];
	
	if (!results)
    {
		NSLog(@"Unresolved error while fetching %@ %@", [error localizedDescription], [error userInfo]);
		
		return nil;
	}
	
	if ([results count])
		return [results objectAtIndex:0];
	
	return nil;
}

- (BOOL)isFavorite:(REItem *)aRevision
{
    Favorite *favorite = [self favoriteWithTitle:aRevision.title];
	
	if (favorite)
        return YES;
    
    return NO;
}

- (void)saveFavorite
{
    Favorite *favorite = [self favoriteWithTitle:revision.title];
	
	if (favorite)
		return;
    
	favorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext];
	favorite.title = revision.title;
    
    NSError *error;
	if (![self.managedObjectContext save:&error])
    {
		NSLog(@"Unresolved error while saving %@ %@", [error localizedDescription], [error userInfo]);
	}
}

- (IBAction)addToFavorites:(id)sender
{
    [self saveFavorite];
    [self reloadData];
}

#pragma mark - Notification support

- (BOOL)hasNotification:(REItem *)aRevision
{
    for (UILocalNotification *localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        NSDate *notifRevisionDate = [localNotif.userInfo valueForKey:@"revisionDate"];
        
        if ([localNotif.alertBody isEqualToString:aRevision.title] &&
            [notifRevisionDate compare:aRevision.date] == NSOrderedSame)
            return YES;
    }
    return NO;
}

- (void)scheduleLocalNotificationForDate:(NSDate *)aDate
{
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] == 64)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"System error", nil)
                                                            message:NSLocalizedString(@"The total amount of 64 local notifications has been reached. No more notifications can be scheduled at this moment.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return;
    }
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:aDate];
    [comp setSecond:0];
    
    NSDate *fireDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification)
    {
        NSArray *objects = [NSArray arrayWithObjects:revision.title, revision.date, revision.info, revision.link, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"revisionTitle", @"revisionDate", @"revisionInfo", @"revisionLink", nil];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        localNotification.fireDate = fireDate;
        localNotification.alertBody = revision.title;
        localNotification.userInfo = userInfo;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [localNotification release];
    }
    
    [self reloadData];
}

- (void)presentNotificationDateError
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Date error", nil)
                                                        message:NSLocalizedString(@"Please select a future date", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (IBAction)addNotification:(id)sender
{
    notifActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"\n\n\n\n\n\n\n\n\n\n\n\n\n", nil)
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    [notifActionSheet showInView:self.view];
    [notifActionSheet addSubview:toolbar];
    [notifActionSheet addSubview:datePicker];
    
    datePicker.date = [self dateToNext5Minutes:[NSDate date]];
    datePicker.maximumDate = self.revision.date;
    datePicker.frame = CGRectMake(0.0,
                                  44.0,
                                  datePicker.frame.size.width,
                                  datePicker.frame.size.height);
}

- (IBAction)submitDatePicker:(id)sender
{
    [notifActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([datePicker.date compare:[NSDate date]] == NSOrderedAscending)
    {
        [self performSelector:@selector(presentNotificationDateError)
                   withObject:nil
                   afterDelay:0.25];
        return;
    }
    
    [self scheduleLocalNotificationForDate:datePicker.date];
}


- (IBAction)cancelDatePicker:(id)sender
{
    [notifActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
}

#pragma mark - Date support

- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM d";
	
	return [dateFormatter autorelease];
}

- (NSDate *)dateToNext5Minutes:(NSDate *)aDate
{
    NSDateComponents *time = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:aDate];
    NSInteger minutes = time.minute;
    
    int remain = minutes % 5;
    
    return [NSDate dateWithTimeIntervalSinceNow:60 * (5 - remain)];
}

#pragma mark - Sharing

- (IBAction)share:(id)sender
{
    shareActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"Email", nil), nil];
    [shareActionSheet showInView:self.view.superview];
    [shareActionSheet release];
}


#pragma mark - Mail composer support

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)shareMail {
    
    if (![MFMailComposeViewController canSendMail])
    {
		NSLog(@"Device is unable to send email in its current state.");
        
		return;
	}
	
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    [mailController setSubject:self.revision.title];
    
	NSString *link = [NSString stringWithFormat:@"%@", self.revision.link];
	NSString *url = [NSString stringWithFormat:@"<a href=\"%@\">%@</a><br /><br />", link, link];
	NSString *body = [NSString stringWithFormat:@"%@", url];
	
	[mailController setMessageBody:body isHTML:YES];
	
	[self presentModalViewController:mailController animated:YES];
    [mailController release];
}

#pragma mark Alert view delegation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelector:@selector(addNotification:)
               withObject:nil
               afterDelay:0.25];
}

#pragma mark - Action sheet delegation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == shareActionSheet)
    {
        switch (buttonIndex)
        {
            case 0 :
            {
                [self shareMail];
                
                break;
            }
        }
    }
}

@end
