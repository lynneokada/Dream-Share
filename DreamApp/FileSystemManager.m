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

@implementation FileSystemManager {
    NSString *masterDreamFolderPath;
}

+ (instancetype) sharedManager {
    static FileSystemManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init {
    if (self = [super init]) {
        [self createMasterDreamFolderIfNonExistent];
    }
    return self;
}

- (void) createMasterDreamFolderIfNonExistent
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

- (void)newDreamTo:(NSString*) dreamFolderPath withContent:(NSString*) dreamContent
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dreamFolderPath])
    {
        //date formatter
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
        
        dreamFolderPath = [masterDreamFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [dateFormatter stringFromDate:date]]];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *dreamContentPath = [NSString stringWithFormat:@"%@/dreamContent.txt", dreamFolderPath];
    
    NSData *dreamContentData = [dreamContent dataUsingEncoding:NSASCIIStringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:dreamContentPath contents:dreamContentData attributes:NULL];
}

- (NSMutableArray*) getMyDreams {

    NSMutableArray *masterDreamFolderContent = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:masterDreamFolderPath error:NULL] mutableCopy];

    return masterDreamFolderContent;
}
@end
