//
//  DreamListTableViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DreamListTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *privateDreamList;
@property (nonatomic, strong) NSMutableArray *recordingsToBeEditted;
@property (strong, nonatomic) NSMutableArray *publicDreamList;

@end
