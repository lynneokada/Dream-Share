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
#import "Tag.h"
#import "FileSystemManager.h"
#import "AppDelegate.h"
#import "RecordViewController.h"
#import "ProfileManager.h"
#import "ServerManager.h"
#import "CoreDataManager.h"
#import "ProfileManager.h"

@interface AddDreamViewController ()
{
    NSMutableArray *dreamTags;
    BOOL saveDream;
}

@property (retain, nonatomic) UIToolbar *keyboardToolBar;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation AddDreamViewController {
    NSString *stringHolder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.delegate = self;
    self.textField.delegate = self;
    self.titleTextField.delegate = self;
    
    dreamTags = [[NSMutableArray alloc] init];
    stringHolder = @"";
    self.textField.text = @"";
    
    if (self.keyboardToolBar == nil) {
        self.keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        self.keyboardToolBar.translucent = NO;
        self.keyboardToolBar.backgroundColor = [UIColor colorWithRed:0.2 green:0.243 blue:0.282 alpha:1];
        self.keyboardToolBar.barTintColor = [UIColor colorWithRed:0.2 green:0.243 blue:0.282 alpha:1];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        done.tintColor = [UIColor whiteColor];
        
        [self.keyboardToolBar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    }
    
    self.textField.inputAccessoryView = self.keyboardToolBar;
    self.textView.inputAccessoryView = self.keyboardToolBar;
    self.titleTextField.inputAccessoryView = self.keyboardToolBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[UILabel appearanceWhenContainedIn:[UITextField class], nil] setTextColor:[UIColor grayColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    saveDream = NO;
    //does an audio file exist?
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.pathToRecording])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
    
    if (self.textView.text.length == 0)
    {
        self.saveButton.userInteractionEnabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    if (saveDream == NO)
    {
        //DELETE FROM CORE DATA
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        [context deleteObject:self.dreamBeingAdded];
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
    if (textField == self.textField) {
        if (![textField.text isEqualToString:stringHolder])
        {
            [dreamTags addObject:[textField.text substringFromIndex:[stringHolder length]]];
            textField.text = [NSString stringWithFormat:@"%@#%@", stringHolder, [textField.text substringFromIndex:[stringHolder length]]];
            NSLog(@"TAGS: %@", dreamTags);
        }
        
        if ([textField.text characterAtIndex:([textField.text length] - 1)] != ' ')
        {
            NSLog(@"textfield.text length: %lu", (unsigned long)[textField.text length]);
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
        
        //    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        //    if ([[stringHolder stringByTrimmingCharactersInSet: set] length] == 0)
        //    {
        //        NSLog(@"trimming: %@", stringHolder);
        //        stringHolder = textField.text;
        //    } else {
        //
        //    stringHolder = textField.text;
        //    }
        
        stringHolder = textField.text;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self.scrollView setContentOffset:CGPointMake(0, textField.center.y-210) animated:YES];
    }
}

-(void)textFieldDidChange
{
    if ([self.textField.text length] < [stringHolder length])
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
        stringHolder = self.textField.text;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

- (void)resignKeyboard:(id)sender
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
    else if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
    else if ([self.titleTextField isFirstResponder])
    {
        [self.titleTextField resignFirstResponder];
    }
}

-(void)dismissKeyboard {
    [self.textField resignFirstResponder];
}

- (IBAction)unwindToAddDreamViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (IBAction)saveTapped:(id)sender
{
    NSDate *today = [NSDate date];
    
    saveDream = YES;
    NSString *dreamTitle = self.titleTextField.text;
    NSString *dreamContent = self.textView.text;
    
    NSLog(@"today is %@", today);
    self.dreamBeingAdded.last_updated = today;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    self.dreamBeingAdded.dreamDate = [dateFormatter stringFromDate:today];
    self.dreamBeingAdded.dreamTitle = dreamTitle;
    self.dreamBeingAdded.dreamContent = dreamContent;
    self.dreamBeingAdded.dreamer = [ProfileManager sharedManager].user;
    
    NSLog(@"DREAMTAGS: %@", dreamTags);
    //create Tag entity for core data
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    Tag *tagsBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
    NSData *tagsArrayData = [NSKeyedArchiver archivedDataWithRootObject:dreamTags];
    tagsBeingAdded.tagsArray = tagsArrayData;
    self.dreamBeingAdded.tags = tagsBeingAdded;
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    
    [[ServerManager sharedManager] postDream:self.dreamBeingAdded];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recordDream"])
    {
        RecordViewController *recordViewController = [segue destinationViewController];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.pathToRecording])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Are you sure you want to redo your recording?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *yes = [UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                  {
                                      [self.navigationController pushViewController:recordViewController animated:YES];
                                      
                                      NSString *cancelRecording = [NSString stringWithFormat: @"%@/recording.m4a", self.dreamBeingAdded.pathToFolder];
                                      NSError *error;
                                      [[NSFileManager defaultManager] removeItemAtPath:cancelRecording error:&error];
                                  }];
            
            [alert addAction:cancel];
            [alert addAction:yes];
            
            recordViewController.dreamBeingAdded = self.dreamBeingAdded;
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            recordViewController.dreamBeingAdded = self.dreamBeingAdded;
        }
    }
}

@end
