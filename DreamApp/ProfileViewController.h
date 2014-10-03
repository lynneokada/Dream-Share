//
//  ProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
//toolbar buttons
@property (weak, nonatomic) IBOutlet UIBarButtonItem *home;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *add;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *search;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profile;

//profile stats
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;

@end
