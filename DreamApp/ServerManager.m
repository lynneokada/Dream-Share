//
//  ServerManager.m
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ServerManager.h"
#import "Global.h"
#import "User.h"
#import "ProfileManager.h"
#import "AppDelegate.h"

@implementation ServerManager

+ (instancetype) sharedManager {
    static ServerManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)postDream:(Dream *)dream
{
    NSDictionary *dictionaryDreamLog = @{
                                         @"dreamContent": dream.dreamContent,
                                         //@"dreamTags": dream.tags,
                                         //@"dreamComments": dream.comment
                                         };
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/dreams", SERVER_URL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryDreamLog options:0 error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionUploadTask *dataUpload = [urlSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode == 200)
        {
            NSDictionary *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",downloadedJSON);
            //            NSString *userDocumentID = [NSString stringWithUTF8String:[data bytes]];
            //            self.userObjectID = userDocumentID;
            //            //NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //            NSLog(@"userDocumentID: %@", userDocumentID);
            //            NSLog(@"uploaded");
        } else {
            //error handing?
            NSLog(@"wtf");
        }
    }];
    [dataUpload resume];

}

- (void)postUser:(User*)user
{
    NSDictionary *dictionaryUser = @{@"user_id" : user.fbUserID,
                                     @"user_fullname" : user.fbFullName};
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user", SERVER_URL]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryUser options:0 error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionUploadTask *dataUpload = [urlSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode == 200)
        {
            NSString *mongoUserID = [NSString stringWithUTF8String:[data bytes]];
            
            [ProfileManager sharedManager].user.db_id = mongoUserID;
            
            NSLog(@"userDocumentID: %@", mongoUserID);
            NSLog(@"uploaded");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
            });
            
            //NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        } else {
            //error handing?
            NSLog(@"wtf");
        }
    }];
    [dataUpload resume];
}

- (void) getDream:(NSString *)userID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/dreams/%@", SERVER_URL,userID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                          NSInteger responseStatusCode = [httpResponse statusCode];
                                          
                                          if (responseStatusCode == 200 && data)
                                          {
                                              NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"%@",downloadedJSON);
//                                              [dreamArray removeAllObjects];
//                                              for (int i = 0; i < [downloadedJSON count]; i++)
//                                              {
//                                                  [dreamArray addObject:downloadedJSON[i][@"dreamContent"]];
//                                              }
                                          }
                                          else
                                          {
                                        
                                          }
                                      }];
    [dataTask resume];
}

@end
