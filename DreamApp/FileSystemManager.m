//
//  FileSystemManager.m
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "FileSystemManager.h"
#import "Global.h"
#import "Dream.h"

@implementation FileSystemManager
{
    NSString *masterDreamFolderPath;
}

+ (instancetype) sharedManager
{
    static FileSystemManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    if (self = [super init]) {
        [self createMasterDreamFolderIfNotCreated];
    }
    return self;
}

- (void) createMasterDreamFolderIfNotCreated
{
    //FILE SYSTEM
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (NSString*)createDreamFolder
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
    
    NSString *dreamFolderPath = [masterDreamFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [dateFormatter stringFromDate:date]]];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:dreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];

    return dreamFolderPath;
}

- (void) saveNewDreamWithName:(NSString*)name atPath:(NSString*)path withContent:(NSString*)content
{
    
}

- (void) saveNewRecordingWithName:(NSString*)name atPath:(NSString*)path
{
    
}

@end
