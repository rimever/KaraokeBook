//
//  DetailViewController.h
//  KaraokeBook
//
//  Created by Ryohei Miura on 2013/07/21.
//  Copyright (c) 2013年 Ryohei Miura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Music.h"

@interface DetailViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Music *detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *artistField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegment;
@property (weak, nonatomic) IBOutlet UITextView *freewordField;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel2;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel3;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property MPMusicPlayerController *player;

@end
