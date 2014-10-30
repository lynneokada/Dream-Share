//
//  CommentTableViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dream;

@interface CommentTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) Dream *dream;

@end