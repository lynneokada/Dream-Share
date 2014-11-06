//
//  Tag.h
//  DreamApp
//
//  Created by Lynne Okada on 11/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Dream;

@interface Tag : SyncableDBObject

@property (nonatomic, retain) NSData * tagsArray;
@property (nonatomic, retain) Dream *taggedDream;

@end
