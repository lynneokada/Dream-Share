//
//  Dream.h
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Dream : NSManagedObject

@property (nonatomic, retain) NSData *recording;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSString *content;

@end
