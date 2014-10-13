//
//  EditDreamViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ProfileViewController.h"

@interface EditDreamViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITextViewDelegate, UITextFieldDelegate>

#pragma message "IBOutlets should be set up in the '.m' file instead of the '.h' file"

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *editLaterButton;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

- (IBAction)playTapped:(id)sender;


@end
