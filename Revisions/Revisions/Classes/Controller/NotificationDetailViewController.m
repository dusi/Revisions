//
//  NotificationDetailViewController.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "DescriptionTableViewCell.h"

@implementation NotificationDetailViewController

@synthesize localNotification;

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
    
    [localNotification release];
    [tableView release];
    [deleteActionSheet release];
    [shareActionSheet release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)reloadData
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.title = [self.localNotification.userInfo valueForKey:@"revisionTitle"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView standardCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RevisionDetailCell";
    
	UITableViewCell *cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
    
    switch (indexPath.row)
    {
        case 0:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"HH:mm - dd/MM/yyyy";
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"Notification date", nil);
            cell.detailTextLabel.text = [[dateFormatter stringFromDate:self.localNotification.fireDate] capitalizedString];
            
            [dateFormatter release];
            
            break;
        }
        case 1:
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd/MM/yyyy";
            
            NSDate *revisionDate = [self.localNotification.userInfo valueForKey:@"revisionDate"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"Date", nil);
            cell.detailTextLabel.text = [[dateFormatter stringFromDate:revisionDate] capitalizedString];
            
            [dateFormatter release];
            
            break;
        }
    }
    
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView descriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RevisionDescriptionCell";
    
	DescriptionTableViewCell *cell = (DescriptionTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[DescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
    
    NSString *revisionInfo = [self.localNotification.userInfo valueForKey:@"revisionInfo"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = NSLocalizedString(@"Description", nil);
    cell.detailTextLabel.text = revisionInfo;
    
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0 :
        {
            return [self tableView:aTableView standardCellAtIndexPath:indexPath];
        }
        case 1 :
        {
            return [self tableView:aTableView standardCellAtIndexPath:indexPath];
        }
        case 2 :
        {
            return [self tableView:aTableView descriptionCellAtIndexPath:indexPath];
        }
    }
    
    return nil;
}

#pragma mark - Table view delegation

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        NSString *revisionInfo = [self.localNotification.userInfo valueForKey:@"revisionInfo"];
        
        return [self heightForDescription:revisionInfo];
    }
    
    return 60.0;
}

#pragma mark Handling notifications

- (void)deleteNotification
{
    if (self.localNotification)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
        [self reloadData];
    }
}

- (IBAction)deleteNotification:(id)sender
{
    deleteActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Delete", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                      destructiveButtonTitle:NSLocalizedString(@"Delete", nil)
                                           otherButtonTitles:nil];
    [deleteActionSheet showInView:self.view.superview];
    [deleteActionSheet release];
}

#pragma mark - Sharing

- (void)shareMail
{
    if (![MFMailComposeViewController canSendMail])
    {
		NSLog(@"Device is unable to send email in its current state.");
		return;
	}
    
    NSString *revisionTitle = [self.localNotification.userInfo valueForKey:@"revisionTitle"];
    NSString *revisionLink = [self.localNotification.userInfo valueForKey:@"revisionLink"];
	
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    [mailController setSubject:revisionTitle];
    
	NSString *link = [NSString stringWithFormat:@"%@", revisionLink];
	NSString *url = [NSString stringWithFormat:@"<a href=\"%@\">%@</a><br /><br />", link, link];
	NSString *body = [NSString stringWithFormat:@"%@", url];
	
	[mailController setMessageBody:body isHTML:YES];
	
	[self presentModalViewController:mailController animated:YES];
    [mailController release];
}

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

#pragma mark - Action sheet support

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == deleteActionSheet)
    {
        deleteActionSheet = nil;
        
        switch (buttonIndex)
        {
            case 0:
            {
                [self deleteNotification];
                
                break;
            }
        }
    }
    
    else if (actionSheet == shareActionSheet)
    {
        shareActionSheet = nil;
        
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

#pragma mark - Mail composer support

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
