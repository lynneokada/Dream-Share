//
//  CoreDataManager.m
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

@implementation CoreDataManager
{
    
}

+ (instancetype) sharedManager {
    static CoreDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init {
    if (self = [super init])
    {
        
    }
    return self;
}

- (NSMutableArray*) requestDreams
{
    // get access to the managed object context
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // get entity description for entity we are selecting
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Dream" inManagedObjectContext:context];
    // create a new fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // create an error variable to pass to the execute method
    NSError *error;
    // retrieve results
    NSMutableArray* fetchedDreams = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (fetchedDreams == nil) {
        //error handling, e.g. display error to user
    }
    //NSLog(@"fetchedDreams: %@", fetchedDreams);
    
    return fetchedDreams;
}

- (NSMutableArray*) requestUserInfo
{
    // get access to the managed object context
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // get entity description for entity we are selecting
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    // create a new fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // create an error variable to pass to the execute method
    NSError *error;
    // retrieve results
    NSMutableArray* fetchedUser = [[context executeFetchRequest:request error:&error]mutableCopy];
    if (fetchedUser == nil) {
        //error handling, e.g. display error to user
    }
    
    return fetchedUser;
}

@end
