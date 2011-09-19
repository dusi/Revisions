//
//  FavoritesViewController.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Favorite.h"
#import "PlaceholderView.h"

@implementation FavoritesViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController;

#pragma mark - Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
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
    [fetchedResultsController release];
    [tableView release];
    [placeholderView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)reloadData
{
    NSInteger numberOfFetchedObjects = [self.fetchedResultsController.fetchedObjects count];
    self.navigationItem.rightBarButtonItem = (numberOfFetchedObjects) ? self.editButtonItem : nil;
    
    placeholderView.hidden = numberOfFetchedObjects;
	tableView.hidden = !numberOfFetchedObjects;
    
    [tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Favorites", nil);
    self.navigationItem.rightBarButtonItem = ([self.fetchedResultsController.fetchedObjects count]) ? self.editButtonItem : nil;
    
    placeholderView.text = NSLocalizedString(@"No favorites", nil);
    placeholderView.type = PlaceholderTypeNoData;
    
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error])
    {
		NSLog(@"Unresolved error while fetching %@ %@", [error localizedDescription], [error userInfo]);
	}
	
	[self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
	return sectionInfo.numberOfObjects;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Favorite *favorite = (Favorite *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = favorite.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"FavoriteCell";
    
	UITableViewCell *cell = (UITableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
	[self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Favorite *favorite = (Favorite *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.managedObjectContext deleteObject:favorite];
        
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error while saving %@ %@", [error localizedDescription], [error userInfo]);
        }
    }
    
    if (![self.fetchedResultsController.fetchedObjects count])
    {
		[self setEditing:NO animated:YES];
		[self reloadData];
	}
}


#pragma mark -
#pragma mark UITableViewDelegate

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Editing support

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [tableView beginUpdates];
    [tableView setEditing:editing animated:animated];
    [tableView endUpdates];
}

#pragma mark - Fetched results controller

- (NSFetchRequest *)fetchRequest
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	NSArray *descriptors = [NSArray arrayWithObject:descriptor];
	[descriptor release];
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:self.managedObjectContext]];
    [request setSortDescriptors:descriptors];
	
	return [request autorelease];
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (!fetchedResultsController)
    {
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest]
																	   managedObjectContext:self.managedObjectContext
																		 sectionNameKeyPath:nil
																				  cacheName:nil];
		fetchedResultsController.delegate = self;
	}
	
	return fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *aTableView = tableView;
	
    switch(type)
    {
        case NSFetchedResultsChangeDelete:
        {
			if (aTableView.dataSource == self)
            {
				[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
			}
			
            break;
        }
    }
}

@end
