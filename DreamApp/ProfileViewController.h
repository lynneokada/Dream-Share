//
//  ProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDelegate>
//toolbar buttons
@property (weak, nonatomic) IBOutlet UIBarButtonItem *home;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *add;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *search;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profile;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//profile stats

@end
