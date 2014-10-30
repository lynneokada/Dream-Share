//
//  Tag.h
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Dream;

@interface Tag : SyncableDBObject

@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSSet *taggedDream;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addTaggedDreamObject:(Dream *)value;
- (void)removeTaggedDreamObject:(Dream *)value;
- (void)addTaggedDream:(NSSet *)values;
- (void)removeTaggedDream:(NSSet *)values;

@end
