//
//  FileSystemManager.h
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemManager : NSObject

+ (instancetype) sharedManager;

- (void)newDreamTo:(NSString*) dreamFolderPath withContent:(NSString*) dreamContent;
- (NSMutableArray*)getMyDreams;

@end
