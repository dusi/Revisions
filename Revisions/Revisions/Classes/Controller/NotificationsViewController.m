//
//  NotificationsViewController.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationsViewController.h"
#import "PlaceholderView.h"
#import "NotificationDetailViewController.h"

@interface NotificationsViewController ()
- (NSDateFormatter *)dateFormatter;
@end

@implementation NotificationsViewController

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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
    
    [tableView release];
    [placeholderView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)reloadData
{
    NSInteger numberOfLocalNotifications = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    
    self.navigationItem.rightBarButtonItem = (numberOfLocalNotifications) ? self.editButtonItem : nil;
    
    placeholderView.hidden = numberOfLocalNotifications;
	tableView.hidden = !numberOfLocalNotifications;
    
    [tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Notifications", nil);
    self.navigationItem.rightBarButtonItem = ([[[UIApplication sharedApplication] scheduledLocalNotifications] count]) ? self.editButtonItem : nil;
    
    placeholderView.text = NSLocalizedString(@"No notifications", nil);
    placeholderView.type = PlaceholderTypeNoData;
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
    return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notif = [notificationArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = notif.alertBody;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Fire at", nil), [[self.dateFormatter stringFromDate:notif.fireDate] capitalizedString]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"NotificationCell";
    
	UITableViewCell *cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
	[self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILocalNotification *localNotif = [[[UIApplication sharedApplication] scheduledLocalNotifications] objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
        
        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (![[[UIApplication sharedApplication] scheduledLocalNotifications] count])
    {
		[self setEditing:NO animated:YES];
		[self reloadData];
	}
}


#pragma mark - Table view delegation

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILocalNotification *localNotification = [[[UIApplication sharedApplication] scheduledLocalNotifications] objectAtIndex:indexPath.row];
    
    NotificationDetailViewController *controller = [[NotificationDetailViewController alloc] initWithNibName:@"NotificationDetailView" bundle:nil];
    controller.localNotification = localNotification;
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Editing support

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [tableView beginUpdates];
    [tableView setEditing:editing animated:animated];
    [tableView endUpdates];
}

#pragma mark - Date formatter

- (NSDateFormatter *)dateFormatter
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm - dd/MM/yyyy";
	
	return [dateFormatter autorelease];;
}

@end
