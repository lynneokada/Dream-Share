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

@interface RecordViewController ()
{
    NSString *_dreamFolderPath;
    NSURL *_tempURL;
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
    NSString *masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    NSLog(@"masterDreamFolderPath: %@", masterDreamFolderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    //date formatter
    NSDate *date = [NSDate date];
//#pragma message "ideally you create DateFormatters as static (class) variables and only create them once; they take quite a lot of CPU time to create"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
    
    _dreamFolderPath = [masterDreamFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [dateFormatter stringFromDate:date]]];
    
    NSLog(@"dreamFolderPath: %@",_dreamFolderPath);
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:_dreamFolderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_dreamFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
        //Create folder
        NSLog(@"Create file.");
    }
    
    NSString *file = [_dreamFolderPath stringByAppendingPathComponent:@"/dreamRecording.m4a"];
    NSLog(@"file: %@", file);
    
    _tempURL = [NSURL fileURLWithPath:file];
    
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
    self.myRecorder= [[AVAudioRecorder alloc] initWithURL:_tempURL settings:recordSetting error:NULL];
    self.myRecorder.delegate = self;
    self.myRecorder.meteringEnabled = YES;
    [self.myRecorder prepareToRecord];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.createdAudioFile = NO;
    [doneBarButton setEnabled:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.myRecorder stop];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    NSLog(@"Finished recording");
}

- (IBAction)recordPauseTapped:(id)sender {
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

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordPauseButton setTitle:@"RECORD" forState:UIControlStateNormal];
    
    [doneBarButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditDreamViewController *editDreamViewController = [segue destinationViewController];
    
    editDreamViewController.audioURL = _tempURL;
    editDreamViewController.dreamFolderPath = _dreamFolderPath;
    NSLog(@"dream folder path: %@", _dreamFolderPath);
    NSLog(@"Sending the ulr to edit screen: %@", _tempURL);
}

@end
