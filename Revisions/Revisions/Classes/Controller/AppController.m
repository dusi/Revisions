//
//  AppController.m
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "ApplicationDefaults.h"
#import "FavoritesViewController.h"
#import "RevisionsViewController.h"

@interface AppController ()
- (void)showAlertWithLocalNotification:(UILocalNotification *)localNotif;
- (void)configureTabBarController;
- (void)configureViewControllers;
@end

@implementation AppController

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;;
@synthesize revisionsNavController;
@synthesize notificationsNavController;
@synthesize favoritesNavController;
@synthesize dateFormatter;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize operationQueue = __operationQueue;
@synthesize applicationDefaults = __applicationDefaults;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
        [self showAlertWithLocalNotification:localNotif];
    
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [revisionsNavController release];
    [notificationsNavController release];
    [favoritesNavController release];
    [dateFormatter release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [__operationQueue release];
    [__applicationDefaults release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureTabBarController];
    [self configureViewControllers];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Revisions" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Revisions.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSOperationQueue *)operationQueue
{
	if (!__operationQueue)
		__operationQueue = [[NSOperationQueue alloc] init];
	
	return __operationQueue;
}

- (ApplicationDefaults *)applicationDefaults
{
    if (!__applicationDefaults)
    {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ApplicationDefaults"
                                                             inManagedObjectContext:self.managedObjectContext];
        
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityDescription];
		
		NSError *error;
		NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
        
		[request release];
		
		if (!results)
			NSLog(@"Unresolved error while fetching %@ %@", error, [error userInfo]);
		
		if ([results count])
			__applicationDefaults = [[results objectAtIndex:0] retain];
        
		else
			__applicationDefaults = [[NSEntityDescription insertNewObjectForEntityForName:@"ApplicationDefaults"
                                                                   inManagedObjectContext:self.managedObjectContext] retain];
	}
    
    return __applicationDefaults;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - User interface

- (void)configureTabBarController
{
    self.tabBarController.selectedIndex = [self.applicationDefaults.lastTabSelected integerValue];
    
    self.revisionsNavController.tabBarItem.title = NSLocalizedString(@"Revisions", nil);
    self.notificationsNavController.tabBarItem.title = NSLocalizedString(@"Notifications", nil);
}

- (void)configureViewControllers
{
    RevisionsViewController *revisionsViewController = (RevisionsViewController *)[revisionsNavController.viewControllers objectAtIndex:0];
    revisionsViewController.managedObjectContext = self.managedObjectContext;
    revisionsViewController.operationQueue = self.operationQueue;
    
    FavoritesViewController *favoritesViewController = (FavoritesViewController *)[favoritesNavController.viewControllers objectAtIndex:0];
    favoritesViewController.managedObjectContext = self.managedObjectContext;
}

#pragma mark - Tab bar delegation

- (void)tabBarController:(UITabBarController *)aTabBarController didSelectViewController:(UIViewController *)viewController
{
    self.applicationDefaults.lastTabSelected = [NSNumber numberWithInteger:aTabBarController.selectedIndex];
}

#pragma mark Date formatter

- (NSDateFormatter *)dateFormatter
{
	if (!dateFormatter)
    {
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"MMM d";
	}
	return dateFormatter;
}

#pragma mark - Local notifications support

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)localNotif
{
    if (localNotif)
        [self showAlertWithLocalNotification:localNotif];
}

- (void)showAlertWithLocalNotification:(UILocalNotification *)localNotif
{
    NSString *title = [localNotif.userInfo valueForKey:@"revisionTitle"];
    NSString *date = [self.dateFormatter stringFromDate:[localNotif.userInfo valueForKey:@"revisionDate"]];
    NSString *info = [localNotif.userInfo valueForKey:@"revisionInfo"];
    NSString *message = [NSString stringWithFormat:@"%@ - %@", date, info];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Alert view support

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocalNotificationRefreshNotifications" object:nil];
}

@end
