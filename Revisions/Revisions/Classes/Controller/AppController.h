//
//  AppController.h
//  Revisions
//
//  Created by Dušátko Pavel on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationDefaults;

@interface AppController : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *revisionsNavController;
@property (nonatomic, retain) IBOutlet UINavigationController *notificationsNavController;
@property (nonatomic, retain) IBOutlet UINavigationController *favoritesNavController;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSOperationQueue *operationQueue;
@property (nonatomic, retain) ApplicationDefaults *applicationDefaults;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
