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
    NSString *dreamFolderPath;
    Dream *dreamBeingAdded;
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

- (NSString*)createDreamFolderIfNotCreated
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
    NSLog(@"DREAMFOLDERPATH: %@", dreamFolderPath);
    return dreamFolderPath;
}

- (NSString*)newDreamWithContent:(NSString*) dreamContent
{
    [self createDreamFolderIfNotCreated];
    
    NSString *dreamContentPath = [NSString stringWithFormat:@"%@/dreamContent.txt", dreamFolderPath];
    
    NSData *dreamContentData = [dreamContent dataUsingEncoding:NSASCIIStringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:dreamContentPath contents:dreamContentData attributes:NULL];
    
    NSLog(@"DREAM CONTENT PATH: %@", dreamContentPath);
    return dreamContentPath;
}

- (NSURL*) newRecording
{
    [self createDreamFolderIfNotCreated];
    
    NSString *file = [NSString stringWithFormat:@"%@/dreamRecording.m4a", dreamFolderPath];
    NSLog(@"FILE: %@", file);
    
    NSURL *tempURL = [NSURL fileURLWithPath:file];
    
    NSLog(@"RECPRDING_URL: %@", tempURL);
    return tempURL;
}

- (NSMutableArray*) getMyDreams {

    NSMutableArray *masterDreamFolderContent = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:masterDreamFolderPath error:NULL] mutableCopy];

    return masterDreamFolderContent;
}

//- (void)accessDreamFolders
//{
//    NSString *dreamFolders = [NSString stringWithFormat:@"%@", masterDreamFolderPath];
//}
@end
