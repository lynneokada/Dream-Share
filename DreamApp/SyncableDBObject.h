//
//  SyncableDBObject.h
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SyncableDBObject : NSManagedObject

@property (nonatomic, retain) NSString * db_id;
@property (nonatomic, retain) NSDate * last_updated;

@end
