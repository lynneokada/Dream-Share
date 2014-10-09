//
//  AddAlarmViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAlarmViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UILabel *currentTime;
    NSTimer *timer;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (nonatomic, strong) NSMutableArray *alarms;

- (void)updateTimer;

@end