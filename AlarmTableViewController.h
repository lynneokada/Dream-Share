//
//  AlarmTableViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;

@interface AlarmTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *alarms;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;
@property (nonatomic, strong) NSString *ampm;

@property (nonatomic, strong) Alarm *alarm;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;

@end
