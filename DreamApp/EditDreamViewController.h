//
//  EditDreamViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EditDreamViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSMutableArray *privateDreamList;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

- (IBAction)playTapped:(id)sender;

@end
