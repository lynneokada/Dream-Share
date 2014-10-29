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

- (NSString*)newDreamWithContent:(NSString*) dreamContent;
- (NSURL*) newRecording;

@end
