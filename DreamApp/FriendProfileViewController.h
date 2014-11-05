//
//  FriendProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 11/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *friendName;
@property (nonatomic, strong) NSString *friendID;

@end
