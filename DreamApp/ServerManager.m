//
//  ServerManager.m
//  DreamApp
//
//  Created by Lynne Okada on 10/27/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ServerManager.h"
#import "Global.h"

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

- (void)postDream:(Dream*) dream{
    
    NSDictionary *dictionaryDreamLog = @{@"user_id": dream.dreamer,
                                         @"dreamContent": dream.dreamContent
                                         };

    NSURL *url = [NSURL URLWithString:SERVER_URL];

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
            //NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"uploaded");
        } else {
            //error handing?
        }
    }];
    [dataUpload resume];
}

/*
- (void) getDream:(NSString*)dreamer_id {
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                                       NSInteger responseStatusCode = [httpResponse statusCode];
                                                       
                                                       if (responseStatusCode == 200 && data) {
                                                           NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                           // do something with this data
                                                           // if you want to update UI, do it on main queue
                                                           [dreamCollection removeAllObjects];
                                                           for (int i = 0; i < [downloadedJSON count]; i++) {
                                                               [dreamCollection addObject:downloadedJSON[i][@"content"]];
                                                           }
                                                       } else {
                                                           // error handling
                                                       }
                                                   }];
    [dataTask resume];
}
*/
@end
