//
//  Dream.h
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Comment, Tag, User;

@interface Dream : SyncableDBObject

@property (nonatomic, retain) NSString * recordingName;
@property (nonatomic, retain) NSString * pathToFolder;
@property (nonatomic, retain) NSString * dreamContent;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *dreamer;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Dream (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
