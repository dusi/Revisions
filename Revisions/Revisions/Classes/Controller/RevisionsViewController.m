//
//  RevisionsViewController.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RevisionsViewController.h"
#import "REItem.h"
#import "REItemsRequest.h"
#import "REItemsResponse.h"
#import "Favorite.h"
#import "PlaceholderView.h"
#import "RevisionTableViewCell.h"
#import "RevisionDetailViewController.h"

@interface RevisionsViewController ()
- (NSDateFormatter *)dateFormatter;
- (void)startLoadingRequest;
- (BOOL)isFavorite:(REItem *)revision;
@end

@implementation RevisionsViewController

@synthesize managedObjectContext;
@synthesize operationQueue;

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        hasLoaded = NO;
		
		revisions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        hasLoaded = NO;
		
		revisions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [managedObjectContext release];
    [operationQueue release];
    [currentRequest cancel];
    [currentRequest release];
    [revisions release];
    [tableView release];
    [placeholderView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)reloadData
{
    placeholderView.hidden = [revisions count];
	tableView.hidden = ![revisions count];
    
    [tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Revisions", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!hasLoaded)
    {
		hasLoaded = YES;
		
		[self startLoadingRequest];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadData];
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
	return [revisions count];
}

- (void)configureCell:(RevisionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    REItem *revision = [revisions objectAtIndex:indexPath.row];
    
    UIColor *cellColor = ([self isFavorite:revision]) ? [UIColor colorWithRed:0.929 green:0.953 blue:0.996 alpha:1.0] : [UIColor whiteColor];
    
    cell.backgroundView.backgroundColor = cellColor;
    cell.textLabel.text = [self.dateFormatter stringFromDate:revision.date];
    cell.textLabel.backgroundColor = cellColor;
    cell.detailTextLabel.text = revision.title;
    cell.detailTextLabel.backgroundColor = cellColor;
    cell.contentView.backgroundColor = cellColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"RevisionCell";
    
	RevisionTableViewCell *cell = (RevisionTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[RevisionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
    
	[self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

#pragma mark - Table view delegation

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    REItem *revision = [revisions objectAtIndex:indexPath.row];
    
    RevisionDetailViewController *revisionDetailViewController = [[RevisionDetailViewController alloc] initWithNibName:@"RevisionDetailView" bundle:nil];
    revisionDetailViewController.managedObjectContext = self.managedObjectContext;
    revisionDetailViewController.revision = revision;
    revisionDetailViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:revisionDetailViewController animated:YES];
    [revisionDetailViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Date formatter

- (NSDateFormatter *)dateFormatter
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM d";
    
    return [dateFormatter autorelease];
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
		NSLog(@"Unresolved error while fetching : %@ %@", [error localizedDescription], [error userInfo]);
		
		return nil;
	}
	
	if ([results count])
		return [results objectAtIndex:0];
	
	return nil;
}

- (BOOL)isFavorite:(REItem *)revision
{
    Favorite *favorite = [self favoriteWithTitle:revision.title];
	
	if (favorite)
        return YES;
    
    return NO;
}

#pragma mark - Data requests

- (void)startLoadingRequest
{
    [placeholderView setType:PlaceholderTypeLoading];
    
    currentRequest = [[REItemsRequest alloc] init];
    currentRequest.delegate = self;
    
    [self.operationQueue addOperation:currentRequest];
}

#pragma mark - RERequest delegation

- (void)request:(RERequest *)request didFinishWithResponse:(REResponse *)response
{
    if (request == currentRequest)
    {
		currentRequest = nil;
        
        [placeholderView setText:NSLocalizedString(@"No revisions", nil)];
        [placeholderView setType:PlaceholderTypeNoData];
		
		REItemsResponse *revisionsResponse = (REItemsResponse *)response;
		
		[revisions release];
        revisions = [[NSMutableArray alloc] initWithArray:revisionsResponse.revisions];
		
		[self reloadData];
	}
    
    [request release];
}


- (void)request:(RERequest *)request didFailWithError:(NSError *)error
{
    if (request == currentRequest)
    {
		currentRequest = nil;
        
        [placeholderView setType:PlaceholderTypeOffline];
        
        hasLoaded = NO;
	}
    
    [request release];
}

@end
