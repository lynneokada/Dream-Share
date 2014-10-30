//
//  Comment.h
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Dream;

@interface Comment : SyncableDBObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Dream *commentedDream;

@end
