//
//  RecordViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "RecordViewController.h"
#import "EditDreamViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "FileSystemManager.h"

@interface RecordViewController ()
{
    NSString *_dreamFolderPath;
    NSURL *_URL;
}

@end

@implementation RecordViewController

@synthesize doneBarButton, recordPauseButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Disable Stop/Play button when application launches
    [doneBarButton setEnabled:NO];
    
    _URL = [[FileSystemManager sharedManager] newRecording];
    
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
    self.myRecorder= [[AVAudioRecorder alloc] initWithURL:_URL settings:recordSetting error:NULL];
    self.myRecorder.delegate = self;
    self.myRecorder.meteringEnabled = YES;
    [self.myRecorder prepareToRecord];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.createdAudioFile = NO;
    [doneBarButton setEnabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.myRecorder stop];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    NSLog(@"Finished recording");
}

- (IBAction)recordPauseTapped:(id)sender
{
    // Stop the audio player before recording

    self.tabBarController.tabBar.userInteractionEnabled = NO;

    if (!self.myRecorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        [session setActive:YES error:nil];
        
        //start recroding
        [self.myRecorder record];
        
        [recordPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    }
    
    else {
        // Pause recording
        [self.myRecorder pause];
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
    EditDreamViewController *editDreamViewController = [segue destinationViewController];
    
    editDreamViewController.audioURL = _URL;
    editDreamViewController.dreamFolderPath = _dreamFolderPath;
    NSLog(@"dream folder path: %@", _dreamFolderPath);
    NSLog(@"Sending the ulr to edit screen: %@", _URL);
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

@end
