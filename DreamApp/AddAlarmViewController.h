//
//  AddAlarmViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAlarmViewController : UIViewController {
    IBOutlet UILabel *currentTime;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UIPickerView *hour;
@property (weak, nonatomic) IBOutlet UIPickerView *minute;
@property (weak, nonatomic) IBOutlet UIPickerView *ampm;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (void)updateTimer;
@end
