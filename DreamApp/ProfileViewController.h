//
//  ProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITabBarDelegate, UITableViewDataSource, FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dreamLog;

#pragma message "You should create IBOutlet Connections in the .m file instead of the .h. That makes the interface look less cluttered"

//buttonsssssss
@property (weak, nonatomic) IBOutlet UIButton *posts;
@property (weak, nonatomic) IBOutlet UIButton *followers;
@property (weak, nonatomic) IBOutlet UIButton *following;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

@property (nonatomic, strong) NSString *dreamTitle;

//profile
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;

@end
