//
//  AddDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/28/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "AddDreamViewController.h"
#import "Dream.h"
#import "User.h"
#import "FileSystemManager.h"
#import "AppDelegate.h"
#import "RecordViewController.h"
#import "ProfileManager.h"
#import "ServerManager.h"
#import "ProfileManager.h"

@interface AddDreamViewController ()
{
    UIToolbar *keyboardToolBar;
    NSMutableArray *tags;
}

@property (retain, nonatomic) UIToolbar *keyboardToolBar;
@property (nonatomic, strong) NSString *stringHolder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation AddDreamViewController
@synthesize keyboardToolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.delegate = self;
    self.textField.delegate = self;
    
    tags = [[NSMutableArray alloc] init];
    
    if (keyboardToolBar == nil) {
        keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        [keyboardToolBar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    }
    
    self.textField.inputAccessoryView = keyboardToolBar;
    self.textView.inputAccessoryView = keyboardToolBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //does an audio file exist?
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.pathToRecording])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
    
    if (self.textView.text.length == 0) {
        self.saveButton.userInteractionEnabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    if (self.textView.text.length == 0)
    {
        //delete the dream
    }
}

- (IBAction)playTapped:(id)sender
{
    [self.playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSURL *recordingURL = [NSURL fileURLWithPath:self.pathToRecording];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingURL error:nil];
    [self.player setDelegate:self];
    [self.player play];
}

- (IBAction)saveTapped:(id)sender
{
    NSString *dreamContent = self.textView.text;
    
    self.dreamBeingAdded.dreamContent = dreamContent;
    self.dreamBeingAdded.dreamer = [[ProfileManager sharedManager] user];
    
    // TODO think about error handling / whether to write to the server if anything errors out beforehand
    
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    
    [[ServerManager sharedManager] postDream:self.dreamBeingAdded];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.saveButton.userInteractionEnabled = NO;
    } else {
        self.saveButton.userInteractionEnabled = YES;
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.saveButton.userInteractionEnabled = NO;
    } else {
        self.saveButton.userInteractionEnabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:self.stringHolder])
    {
        textField.text = [NSString stringWithFormat:@"%@#%@", self.stringHolder, [textField.text substringFromIndex:[self.stringHolder length]]];
        [tags addObject:[textField.text substringFromIndex:[self.stringHolder length]]];
        NSLog(@"TAGS: %@", tags);
    }
    
    if ([textField.text characterAtIndex:([textField.text length] - 1)] != ' ')
    {
        textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
    }
    
    self.stringHolder = textField.text;
    
    return YES;
}

-(void)textFieldDidChange
{
    if ([self.textField.text length] < [self.stringHolder length])
    {
        int textFieldLength = [self.textField.text length];
        
        for (int i = textFieldLength - 1; i >= 0; i--)
        {
            if ([self.textField.text characterAtIndex:i] == '#')
            {
                self.textField.text = [self.textField.text substringToIndex:i];
                break;
            }
        }
        self.stringHolder = self.textField.text;
    }
}

- (void)resignKeyboard:(id)sender
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    } else if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
}

- (IBAction)unwindToEditDreamViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordDream"])
    {
        RecordViewController *recordViewController = [segue destinationViewController];
        recordViewController.dreamBeingAdded = self.dreamBeingAdded;
    }
}


@end
