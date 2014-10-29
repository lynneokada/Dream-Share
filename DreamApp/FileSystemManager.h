//
//  FileSystemManager.h
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileSystemManager : NSObject

@property (nonatomic, strong) UIImage *FBProfilePicture;

+ (instancetype) sharedManager;

- (NSString*)createDreamFolder;
- (void)saveNewDreamWithName:(NSString*)name atPath:(NSString*)path withContent:(NSString*)content;
- (NSString*) saveNewRecordingWithName:(NSString*)name atPath:(NSString*)path;

@end
