//
//  MasterViewController.h
//  KaraokeBook
//
//  Created by Ryohei Miura on 2013/07/21.
//  Copyright (c) 2013年 Ryohei Miura. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,UISearchDisplayDelegate, UISearchBarDelegate> {
    NSArray* _items;
    NSMutableArray* _filteredListContent;
}
@property (strong, nonatomic) NSMutableArray *filterdSearchArray;
@property IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
