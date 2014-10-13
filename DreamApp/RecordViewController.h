//
//  RecordViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

#pragma message "IBOutlets should be set up in the '.m' file instead of the '.h' file"

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (nonatomic, strong) NSMutableArray *privateDreamList;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
