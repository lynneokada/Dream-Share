//
//  ProfileManager.m
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ProfileManager.h"

@implementation ProfileManager

+ (instancetype) sharedManager
{
    static ProfileManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end
