//
//  ServerManager.h
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dream.h"

@interface ServerManager : NSObject <NSURLSessionDataDelegate>

+ (instancetype) sharedManager;

@property (nonatomic, strong) NSString *userObjectID;

- (void)postDream:(Dream *)dream;
- (void)postUser:(User*) user;
- (void)getDreamsWithUserID:(NSString*)userID andCallbackBlock:(void (^)(NSArray*))callBackBlock;
- (void)getDreamsWithTag:(NSString*)tag andCallbackBlock:(void (^)(NSArray*))callBackBlock;

@end
