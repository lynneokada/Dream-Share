//
//  Alarm.h
//  DreamApp
//
//  Created by Lynne Okada on 10/7/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSString *hour;
@property (nonatomic, retain) NSString *minute;
@property (nonatomic, retain) NSString *ampm;

@end
