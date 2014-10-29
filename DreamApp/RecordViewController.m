//
//  RecordViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "RecordViewController.h"
#import "AddDreamViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "FileSystemManager.h"
#import "Dream.h"

@interface RecordViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (strong, nonatomic) AVAudioRecorder *recorder;

@end

@implementation RecordViewController
@synthesize doneBarButton, recordPauseButton, recorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    [session setActive:YES error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.dreamBeingAdded.pathToFolder] settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [doneBarButton setEnabled:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //stahp recording
    [self.recorder stop];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (IBAction)recordPauseTapped:(id)sender
{
    // Stop the audio player before recording
    
    self.tabBarController.tabBar.userInteractionEnabled = NO;

    if (!self.recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        //start recroding
        [self.recorder record];
        
        [recordPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    }
    else
    {
        // Pause recording
        [self.recorder pause];
        [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    }
    
    [doneBarButton setEnabled:YES];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    
    [doneBarButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddDreamViewController *addDreamViewController = [segue destinationViewController];
    self.dreamBeingAdded.recordingName = @"recording.m4a";
    
    NSString *pathToAudio = [[FileSystemManager sharedManager] saveNewRecordingWithName:self.dreamBeingAdded.recordingName atPath:self.dreamBeingAdded.pathToFolder];
    addDreamViewController.pathToAudio = pathToAudio;
    
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

@end
