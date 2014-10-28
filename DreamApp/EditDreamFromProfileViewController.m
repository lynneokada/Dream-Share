//
//  EditDreamFromProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/21/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "EditDreamFromProfileViewController.h"
#import "Global.h"
#import "FileSystemManager.h"
#import "Dream.h"

@interface EditDreamFromProfileViewController () {
    NSString *masterDreamFolderPath;
    NSString *textFile;
    AVAudioPlayer *player;
}

@property (weak, nonatomic) IBOutlet UITextView *dreamContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *stringHolder;

@end

@implementation EditDreamFromProfileViewController
@synthesize keyboardToolBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //Display dream content
    self.dreamContentTextView.delegate = self;
    self.textField.delegate = self;
    self.commentList = [NSMutableArray new];
    
    self.stringHolder = [NSString stringWithFormat:@""];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if (keyboardToolBar == nil) {
        keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        [keyboardToolBar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    }
    
    self.textField.inputAccessoryView = keyboardToolBar;
    self.dreamContentTextView.inputAccessoryView = keyboardToolBar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //Dream Content
    NSURL *pathToURL = [NSURL fileURLWithPath:self.dream.pathToContent];
    NSString *content = [NSString stringWithContentsOfURL:pathToURL encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"CONTENT: %@", content);
    self.dreamContentTextView.text = content;
    
    //Does audio file exist
    NSLog(@"audioFile exists? %@", self.dream.pathToRecording);
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.dream.pathToRecording])
    {
        [self.playButton setEnabled:NO];
    } else {
        [self.playButton setEnabled:YES];
    }
}

- (IBAction)playTapped:(id)sender
{
    [self.playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSURL *recordingURL = [NSURL fileURLWithPath:self.dream.pathToRecording];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingURL error:nil];
    NSLog(@"RECORDING_URL: %@", recordingURL);
    [player setDelegate:self];
    [player play];
}

- (void) dismissKeyboard
{
    [self.dreamContentTextView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)resignKeyboard:(id)sender {
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    } else if ([self.dreamContentTextView isFirstResponder])
    {
        [self.dreamContentTextView resignFirstResponder];
    }
}

@end
