//
//  AddAlarmViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAlarmViewControllerDelegate <NSObject>

- (void)didChooseHour:(NSString *)hour minute:(NSString *)minute andampm:(NSString *)ampm;

@end

@interface AddAlarmViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UILabel *currentTime;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) id <AddAlarmViewControllerDelegate> delegate;

- (void)updateTimer;

@end
