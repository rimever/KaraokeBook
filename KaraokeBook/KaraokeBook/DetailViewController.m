//
//  DetailViewController.m
//  KaraokeBook
//
//  Created by Ryohei Miura on 2013/07/21.
//  Copyright (c) 2013年 Ryohei Miura. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
- (void)importCSV;
@end

@implementation DetailViewController
@synthesize nameField;
@synthesize artistField;
@synthesize freewordField;

CGRect activeframe;
bool isNew;

#pragma mark - Managing the detail item
@synthesize detailItem = _detailItem;

- (Music *)detailItem {
    if (! _detailItem) {
        _detailItem = [NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:self.managedObjectContext];

        // 再生中の曲があれば、それを反映させる
        _player = [MPMusicPlayerController iPodMusicPlayer];
        MPMediaItem *nowPlayingItem = [_player nowPlayingItem];
        
        if (nowPlayingItem) {
            NSLog(@"再生中の曲情報を反映");
            _detailItem.name = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
            _detailItem.artist = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
            _detailItem.freeword = [nowPlayingItem valueForProperty:MPMediaItemPropertyGenre];
            _detailItem.rate = [[NSNumber alloc]initWithInteger:0];
        }
    }
    return _detailItem;
}

- (void)setDetailItem:(id)newDetailItem
{
    NSLog(@"詳細情報があれば設定");
    if (_detailItem != newDetailItem) {
        NSLog(@"詳細情報があるので設定");
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
    
}

- (void)configureView
{
    NSLog(@"詳細情報の設定");
    if (_detailItem) {
        NSLog(@"編集");
        isNew = false;
    }else{
        NSLog(@"新規登録");
        isNew = true;
    }
    
    // Update the user interface for the detail item.
    [self becomeFirstResponder];
    
    if (self.detailItem) {
        self.nameField.text = self.detailItem.name;
        self.artistField.text = self.detailItem.artist;
        self.freewordField.text = self.detailItem.freeword;
        [self clickRateLabel:self.detailItem.rate.integerValue+1];
    }
}

- (void) done
{
    // 曲名もアーティスト名も空の場合は、警告メッセージ
    if (true
        && [self.nameField.text length] == 0
        && [self.artistField.text length] == 0
        ) {
        UIAlertView *alert_notitle;
        alert_notitle = [[UIAlertView alloc] initWithTitle:@"エラー"
                                           message:@"曲名とアーティスト名が入力されているため、登録できません。"
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert_notitle show];
        return;
    }
    // 新規のときは曲名が登録済みかをチェックする
    if (isNew == true && [self getMusicCount:self.nameField.text] > 0) {
        UIAlertView *alert_done;
        alert_done = [[UIAlertView alloc] initWithTitle:@"警告"
                                                   message:@"この曲名は既に登録されています。それでもよろしいですか？"
                                                  delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        [alert_done show];
        // はいを押したときの処理はデリゲートで行う
        return;
    }
    [self subDone];

}
// 既に登録されている曲名の処理
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //1番目のボタン（cancelButtonTitle）が押されたときのアクション
            break;
            
        case 1:
            //2番目のボタンが押されたときのアクション
            [self subDone];
            break;
            
            
    }
}
// 曲の登録サブルーチン
-(void)subDone {
    self.detailItem.name = self.nameField.text;
    self.detailItem.artist = self.artistField.text;
    self.detailItem.freeword = self.freewordField.text;
    
    int rate = 1;
    if ([_rateLabel3.text isEqual: @"★" ]) {
        rate = 3;
    }else if([_rateLabel2.text isEqual: @"★" ]) {
        rate = 2;
    }else if([_rateLabel1.text isEqual: @"★"]) {
        rate = 1;
    }
    self.detailItem.rate = [[NSNumber alloc]initWithInteger:rate-1];
    
    
    
    NSError *error = nil;
    
    // データの保存
    if (! [self.managedObjectContext save:&error]) {
        // エラーが発生したらログを出力
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
        abort();
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // 一覧画面に戻る
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"画面遷移:曲一覧");
    }
    [self.view endEditing:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    // 新規登録しようとしたが、キャンセルした場合に空のリストを追加しないようにロールバック
    if ([self.managedObjectContext hasChanges]) {
        [self.managedObjectContext rollback];
    }
}

- (void)viewDidLoad
{
    //[self importCSV];
    NSLog(@"画面表示:曲情報　Start");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = item;

    self.scrollView.contentSize=CGSizeMake(320,800);
    
    nameField.delegate = self;
    artistField.delegate = self;
    freewordField.delegate = self;
    
    // ラベルイベントを施すためにタグを設定しておく
    _rateLabel1.userInteractionEnabled = YES;
    _rateLabel1.tag = 101;
    _rateLabel2.userInteractionEnabled = YES;
    _rateLabel2.tag = 102;
    _rateLabel3.userInteractionEnabled = YES;
    _rateLabel3.tag = 103;
    
    
    
    

    
    [_rateLabel1 addGestureRecognizer:
     [[UITapGestureRecognizer alloc]
      initWithTarget:self action:@selector(clickRateLabel1)]];
    [_rateLabel2 addGestureRecognizer:
     [[UITapGestureRecognizer alloc]
      initWithTarget:self action:@selector(clickRateLabel2)]];
    [_rateLabel3 addGestureRecognizer:
     [[UITapGestureRecognizer alloc]
      initWithTarget:self action:@selector(clickRateLabel3)]];
    
    // 枠線の色
    [[self.freewordField layer] setBorderColor:[[UIColor blackColor] CGColor]];
    // 枠線の太さ
    [[self.freewordField layer] setBorderWidth:1.0];
    // 角丸にする
    [[self.freewordField layer] setCornerRadius:10.0];
    [self.freewordField setClipsToBounds:YES];

    [self configureView];
    NSLog(@"画面表示:曲情報　End");
}
// selectorでは引数が渡せないので引数がない、メソッドを宣言
-(IBAction)clickRateLabel1 {
    [self clickRateLabel:1];
}
-(IBAction)clickRateLabel2 {
    [self clickRateLabel:2];
}
-(IBAction)clickRateLabel3 {
    [self clickRateLabel:3];
}
// ラベルをクリックしたときのイベント
-(IBAction)clickRateLabel:(int)rate {
    
    if (rate >= 1) {
        _rateLabel1.text = @"★";
    }else {
        _rateLabel1.text = @"☆";
    }
    if (rate >= 2) {
        _rateLabel2.text = @"★";
    }else {
        _rateLabel2.text = @"☆";
    }
    if (rate >= 3) {
        _rateLabel3.text = @"★";
    }else {
        _rateLabel3.text = @"☆";
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}


-(void)keyboardWillShow:(NSNotification*)note
{
    // キーボードの表示完了時の場所と大きさを取得。
    CGRect keyboardFrameEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    
    NSLog(@"%f %f",(activeframe.origin.y + activeframe.size.height),(screenHeight - keyboardFrameEnd.size.height - 30));
    
    if((activeframe.origin.y + activeframe.size.height)>(screenHeight - keyboardFrameEnd.size.height - 30)){
    	// テキストフィールドがキーボードで隠れるようなら
        // 選択中のテキストフィールドの直ぐ下にキーボードの上端が付くように、スクロールビューの位置を上げる
        CGPoint scrollPoint = CGPointMake(0.0, activeframe.origin.y  - 30);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // メンバ変数activeFieldに選択されたテキストフィールドを代入
    activeframe = textField.frame;
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    activeframe = textView.frame;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.scrollView.frame = CGRectMake(0, 0, 320, screenHeight - 20);
                     }];
    
    [textField resignFirstResponder];
    return YES;
}
/*
 // キーボードでReturnが押された場合の処理
 -(BOOL)textFieldShouldReturn:(UITextField *)textField{
 if([nameField isEqual:textField]){
 //artistFieldへ移動
 [artistField becomeFirstResponder];
 }else if([artistField isEqual:textField]){
 //入力を終了してキーボードを閉じる
 if([textField canResignFirstResponder])[textField resignFirstResponder];
 }
 CGRect screenBounds = [[UIScreen mainScreen] bounds];
 float screenHeight = screenBounds.size.height;
 
 [UIView animateWithDuration:0.2
 animations:^{
 self.scrollView.frame = CGRectMake(0, 0, 320, screenHeight - 20);
 }];
 
 [textField resignFirstResponder];
 return YES;
 }
// キーボードの表示・非表示時に呼び出すメソッド
- (void)registerForKeyboardNotifications
{
    // 表示される直前
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    // 隠される直前
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGPoint scrollPoint = CGPointMake(0.0,200.0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CSVをインポートする
- (void)importCSV
{
    @autoreleasepool {
        NSLog(@"CSVインポート開始");
        // CSV ファイル（ExcelはSJIS）
        NSString *filePath = @"/Users/rim/Desktop/karaokebook.csv";
        NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSShiftJISStringEncoding error:nil];
        BOOL isDirectory;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
            NSLog(@"%@",text);
        }
        
        // 改行文字で区切って配列に格納する(Macはこれ）
        NSArray *lines = [text componentsSeparatedByString:@"\r"];
        NSLog(@"lines count: %d", lines.count);    // 行数
        
        // １行目は必要ない
        for (int i = 1; i < lines.count; i++) {
            NSString *row = lines[i];
            // コンマで区切って配列に格納する
            NSArray *items = [row componentsSeparatedByString:@","];
            NSLog(@"item=%@", items);
            //
            NSString *str_name = items[0];
            NSString *str_artist = items[1];
            NSString *str_freeword = items[3];
            // 3,2,1で入力してもらうので-1演算
            int int_rate= [items[2] intValue] - 1;
            NSNumber *str_rate = [NSNumber numberWithInt:int_rate];
            
            
            Music *new_music =[NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:self.managedObjectContext];
            // インポートさせる
            new_music.name = str_name;
            new_music.artist = str_artist;
            new_music.freeword = str_freeword;
            new_music.rate = str_rate;
            
            NSLog(@"name=%@ artist=%@ freeword=%@ rate=%@",str_name,str_artist,str_freeword,str_rate);
            
            
            NSError *error = nil;
            
            // データの保存
            if (! [new_music.managedObjectContext save:&error]) {
                // エラーが発生したらログを出力
                NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
                abort();
            }
        }
    }
}
- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Detail"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}
- (NSUInteger)getMusicCount:(NSString *)name
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Music" inManagedObjectContext:self.managedObjectContext]];
    [request setIncludesSubentities:NO];
    // 曲名を探す
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [request setPredicate:predicate];

    NSError* error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    
    return count;
}

@end
