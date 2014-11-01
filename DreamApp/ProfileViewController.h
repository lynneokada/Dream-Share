//
//  ProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class User;

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITabBarDelegate, UITableViewDataSource, FBLoginViewDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) User *user;

@end