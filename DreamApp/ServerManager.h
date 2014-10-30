//
//  ServerManager.h
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dream.h"

@interface ServerManager : NSObject

+ (instancetype) sharedManager;

- (void)postDream:(Dream*) dream;

@end
