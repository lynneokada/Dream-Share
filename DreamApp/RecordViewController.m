//
//  RecordViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "RecordViewController.h"
#import "EditDreamViewController.h"
#import "Dream.h"
#import "AppDelegate.h"

@interface RecordViewController () {
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    Dream *dreamBeingAdded;
}

@end

@implementation RecordViewController

#pragma message "Synthesize should not be necessary as this gets added automatically"

@synthesize doneButton, recordPauseButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma message "Properties should get accessed with dot-Syntax: 'doneButton.enabled = NO'"
    // Disable Stop/Play button when application launches
    [doneButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    }
#pragma message "Properties should get accessed with dot-Syntax: 'doneButton.enabled = NO'"

    [doneButton setEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated {
#pragma message "Properties should get accessed with dot-Syntax: 'doneButton.enabled = NO'"

    [doneButton setEnabled:NO];
}

- (IBAction)doneTapped:(id)sender {
    [recorder stop];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
    [player setDelegate:self];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [_privateDreamList addObject:dreamBeingAdded];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    
    [doneButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editDream"]) {
        EditDreamViewController *editDreamViewController = [segue destinationViewController];
        editDreamViewController.recorder = recorder;
        editDreamViewController.player = player;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
