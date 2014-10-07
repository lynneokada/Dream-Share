//
//  AddAlarmViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/6/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "AddAlarmViewController.h"

@interface AddAlarmViewController () {
    NSArray *_hourData;
    NSArray *_minuteData;
    NSArray *_ampmData;
    
    NSString *_hourValue;
    NSString *_minuteValue;
    NSString *_ampmValue;
}

@end

@implementation AddAlarmViewController

- (void)updateTimer {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    currentTime.text = [formatter stringFromDate:[NSDate date]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    
    // Do any additional setup after loading the view.
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    //Initialize UIPickerView data
    _hourData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    _minuteData = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    _ampmData = @[@"am",@"pm"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma picker components
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [_hourData count];
    } else if (component == 1) {
        return [_minuteData count];
    } else {
        return [_ampmData count];
    }
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return _hourData[row];
    } else if (component == 1) {
        return _minuteData[row];
    } else {
        return _ampmData[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger selectedHour = [self.timePicker selectedRowInComponent:0];
    NSInteger selectedMinute = [self.timePicker selectedRowInComponent:1];
    NSInteger selectedampm = [self.timePicker selectedRowInComponent:2];
    
    //NSLog(@"hour:%@, minute:%@, ampm:%@", _hourData[row], _minuteData[row], _ampmData[row]);
    
    if (component == 0) {
        return NSLog(@"Selected hour: %@",[_hourData objectAtIndex:row]);
    } else if (component == 1) {
        return NSLog(@"Selected minute: %@",[_minuteData objectAtIndex:row]);
    } else {
        return NSLog(@"Selected am/pm: %@",[_ampmData objectAtIndex:row]);
    }
    
    //_hourValue = [_hourData objectAtIndex:[pickerView selectedRowInComponent:0]];

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AlarmAdded"]) {
        
    }
}


@end
