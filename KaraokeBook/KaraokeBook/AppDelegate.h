//
//  AppDelegate.h
//  KaraokeBook
//
//  Created by Ryohei Miura on 2013/07/21.
//  Copyright (c) 2013年 Ryohei Miura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UITabBarController *tabBarController;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
