//
//  Music.h
//  KaraokeBook
//
//  Created by Ryohei Miura on 2013/07/21.
//  Copyright (c) 2013年 Ryohei Miura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Music : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * freeword;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSNumber * sing_time;
@property (nonatomic, retain) NSNumber * rate;

@end
