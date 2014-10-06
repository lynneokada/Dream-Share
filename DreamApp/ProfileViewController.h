//
//  ProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITabBarDelegate>
//toolbar buttons
@property (weak, nonatomic) IBOutlet UITabBarItem *home;
@property (weak, nonatomic) IBOutlet UITabBarItem *add;
@property (weak, nonatomic) IBOutlet UITabBarItem *search;
@property (weak, nonatomic) IBOutlet UITabBarItem *profile;


//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//profile stats

@end
