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
#import "Global.h"

@interface RecordViewController () {
    AVAudioPlayer *_player;
    AVAudioRecorder *_recorder;
    Dream *_dreamBeingAdded;
    NSURL *_tempURL;
    UITabBarController *tabBarController;
    NSString *file;
}

@end

@implementation RecordViewController
@synthesize doneBarButton, recordPauseButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Disable Stop/Play button when application launches
    [doneBarButton setEnabled:NO];
    
    // Set the audio file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:AUDIO_DIRECTORY];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    NSLog(@"Create file.");
    }
    
//    //date formatter
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
//    
//    NSString *audioFileDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
//    
//    NSString *file = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.m4a", audioFileDate]];
//    
//    NSLog(@"%@", file);
//    _tempURL = [NSURL fileURLWithPath:file];
//    
//    // Setup audio session
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    
//    // Define the recorder setting
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//    
//    // Initiate and prepare the recorder
//    _recorder = [[AVAudioRecorder alloc] initWithURL:_tempURL settings:recordSetting error:NULL];
//    _recorder.delegate = self;
//    _recorder.meteringEnabled = YES;
//    [_recorder prepareToRecord];
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (_player.playing) {
        [_player stop];
    }
    
    if (!_recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
        [recordPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    } else {
        // Pause recording
        [_recorder pause];
        [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    }
    [doneBarButton setEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [doneBarButton setEnabled:NO];
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:AUDIO_DIRECTORY];
    
    //date formatter
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
    
    NSString *audioFileDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    
    file = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.m4a", audioFileDate]];
    
    NSLog(@"path to the .m4a: %@", file);
    _tempURL = [NSURL fileURLWithPath:file];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:_tempURL settings:recordSetting error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    
    [doneBarButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editDream"]) {
        EditDreamViewController *editDreamViewController = [segue destinationViewController];
        
        [_recorder stop];
        
        editDreamViewController.audioURL = _tempURL;
//        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:nil];
//        [_player setDelegate:self];
//        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setActive:NO error:nil];
//        
//        editDreamViewController.recorder = _recorder;
//        editDreamViewController.player = _player;
    }
    
//    if ([segue.identifier isEqualToString:@"toRecordingList"]) {
//        RecordingsTableViewController *recordingsTableViewController = [segue destinationViewController];
//
//        [_recorder stop];
//        
//        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:NULL];
//        [_player setDelegate:self];
//        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setActive:NO error:nil];
//        
//        recordingsTableViewController.recorder = _recorder;
//        recordingsTableViewController.player = _player;
//    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
