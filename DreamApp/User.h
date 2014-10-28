//
//  User.h
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncableDBObject.h"

@class Dream;

@interface User : SyncableDBObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) Dream *userDream;

@end
