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

@class Comment, Tag, User;

@interface Dream : SyncableDBObject

@property (nonatomic, retain) NSString * recordingName;
@property (nonatomic, retain) NSString * pathToFolder;
@property (nonatomic, retain) NSString * dreamContent;
@property (nonatomic, retain) User *dreamer;
@property (nonatomic, retain) NSSet *tag;
@property (nonatomic, retain) NSSet *comment;
@end

@interface Dream (CoreDataGeneratedAccessors)

- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet *)values;
- (void)removeTag:(NSSet *)values;

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet *)values;
- (void)removeComment:(NSSet *)values;

@end
