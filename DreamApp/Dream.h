//
//  Dream.h
//  DreamApp
//
//  Created by Lynne Okada on 11/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Comment, Tag, User;

@interface Dream : SyncableDBObject

@property (nonatomic, retain) NSString * dreamContent;
@property (nonatomic, retain) NSString * pathToFolder;
@property (nonatomic, retain) NSString * dreamTitle;
@property (nonatomic, retain) NSSet *comment;
@property (nonatomic, retain) User *dreamer;
@property (nonatomic, retain) Tag *tags;
@end

@interface Dream (CoreDataGeneratedAccessors)

- (void)addCommentObject:(Comment *)value;
- (void)removeCommentObject:(Comment *)value;
- (void)addComment:(NSSet *)values;
- (void)removeComment:(NSSet *)values;

@end
