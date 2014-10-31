//
//  User.h
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Dream;

@interface User : SyncableDBObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *userDream;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addUserDreamObject:(Dream *)value;
- (void)removeUserDreamObject:(Dream *)value;
- (void)addUserDream:(NSSet *)values;
- (void)removeUserDream:(NSSet *)values;

@end
