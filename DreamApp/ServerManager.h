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
- (void)postComment:(NSString*)comment withDreamID:(NSString*)dreamID;

- (void)checkForUser:(NSString*)fbUserID andCallbackBlock:(void (^)(NSArray*))callBackBlock;
- (void)getAllDreamsWithBlock:(void (^)(NSArray*))callBackBlock;
- (void)getDreamsWithUserID:(NSString*)userID andCallbackBlock:(void (^)(NSArray*))callBackBlock;
- (void)getDreamsWithTag:(NSString*)tag andCallbackBlock:(void (^)(NSArray*))callBackBlock;
- (void)getCommentsWith:(NSString*)dreamID andCallbackBlock:(void (^)(NSArray*))callBackBlock;

- (void)deleteDreamUsing:(NSString*)dreamdb_id;
- (void)deleteCommentsFromDream:(NSString*)dreamdb_id;

- (void)updateDream:(NSString*)dreamdb_id;
@end
