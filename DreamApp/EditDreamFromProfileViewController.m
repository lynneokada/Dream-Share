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
    
    //Does audio file exist
    NSLog(@"audioFile exists? %@", self.audioFileURL);
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.audioFileURL.path])
    {
        [self.playButton setEnabled:NO];
    } else {
        [self.playButton setEnabled:YES];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.txtURL.path])
    {
        textFile = [NSString stringWithContentsOfURL:self.txtURL encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"textFile: %@", textFile);
        self.dreamContentTextView.text = textFile;
    }
}

- (IBAction)playTapped:(id)sender
{
    [self.playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioFileURL error:nil];
    NSLog(@"%@", self.audioFileURL);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"unwindToProfile"])
    {
        textFile = self.dreamContentTextView.text;
        NSLog(@"textFile in dd: %@", textFile);
        
        NSString *changedDreamContentPath = [NSString stringWithFormat:@"%@/%@/dreamContent.txt", masterDreamFolderPath, _dreamFolderPath];
        NSLog(@"changedDreamContentPath: %@", changedDreamContentPath);
        
        NSData *changedDreamContentData = [textFile dataUsingEncoding:NSASCIIStringEncoding];
        [[NSFileManager defaultManager] createFileAtPath:changedDreamContentPath contents:changedDreamContentData attributes:NULL];
    }
}

@end
