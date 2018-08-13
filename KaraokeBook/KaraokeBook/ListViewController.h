//
//  ListViewController.h
//  KaraokeBook
//
//  Created by Ryohei Miura on 2013/09/01.
//  Copyright (c) 2013年 Ryohei Miura. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface ListViewController : UIViewController <NSFetchedResultsControllerDelegate,UISearchDisplayDelegate, UISearchBarDelegate,UITableViewDelegate> {
    NSArray* _items;
    NSMutableArray* _filteredListContent;
}
@property (strong, nonatomic) NSMutableArray *filterdSearchArray;
@property IBOutlet UISearchBar *searchBar;
@property IBOutlet UITableViewCell *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
