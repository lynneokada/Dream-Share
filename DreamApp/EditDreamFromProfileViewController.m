//
//  EditDreamFromProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/21/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "EditDreamFromProfileViewController.h"
#import "Global.h"

@interface EditDreamFromProfileViewController () {
    NSString *masterDreamFolderPath;
    NSString *textFile;
    AVAudioPlayer *_player;
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
    
    self.stringHolder = [NSString stringWithFormat:@""];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //FILE SYSTEM
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    NSLog(@"%@", masterDreamFolderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
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
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioFileURL error:nil];
    NSLog(@"%@", self.audioFileURL);
    [_player setDelegate:self];
    [_player play];
}

- (void) dismissKeyboard
{
    [self.dreamContentTextView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y - 100), textField.frame.size.width, textField.frame.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    textField.frame = CGRectMake(textField.frame.origin.x, (textField.frame.origin.y + 100.0), textField.frame.size.width, textField.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSLog(@"string holder = \"%@\"", self.stringHolder);
    NSLog(@"textField text = \"%@\"", textField.text);
    
    NSLog(@"New added string %@", [textField.text substringFromIndex:[self.stringHolder length]]);
    
    if (![textField.text isEqualToString:self.stringHolder]) {
        textField.text = [NSString stringWithFormat:@"%@#%@", self.stringHolder, [textField.text substringFromIndex:[self.stringHolder length]]];
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
        NSLog(@"string holder = \"%@\"", self.stringHolder);
    }
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
