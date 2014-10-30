//
//  Dream.h
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"


@interface Dream : SyncableDBObject

@property (nonatomic, retain) NSString * recordingName;
@property (nonatomic, retain) NSString * pathToFolder;
@property (nonatomic, retain) NSString * dreamContent;
@property (nonatomic, retain) NSManagedObject *user;
@property (nonatomic, retain) NSSet *tag;
@property (nonatomic, retain) NSSet *comment;
@end

@interface Dream (CoreDataGeneratedAccessors)

- (void)addTagObject:(NSManagedObject *)value;
- (void)removeTagObject:(NSManagedObject *)value;
- (void)addTag:(NSSet *)values;
- (void)removeTag:(NSSet *)values;

- (void)addCommentObject:(NSManagedObject *)value;
- (void)removeCommentObject:(NSManagedObject *)value;
- (void)addComment:(NSSet *)values;
- (void)removeComment:(NSSet *)values;

@end
