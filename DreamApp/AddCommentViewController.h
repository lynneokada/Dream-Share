//
//  AddCommentViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 11/10/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dream;

@interface AddCommentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) Dream *dream;
@property (nonatomic, strong) NSMutableArray *fetchedComments;

@property (nonatomic, strong) NSString *dream_id;

@end
