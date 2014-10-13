//
//  DreamViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dream;

@interface DreamViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) Dream *dream;

#pragma message "IBOutlets should be set up in the '.m' file instead of the '.h' file"

@property (weak, nonatomic) IBOutlet UITextView *dreamTextView;
@property (weak, nonatomic) IBOutlet UILabel *dreamTitleLabel;


@end
