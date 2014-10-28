//
//  EditDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "EditDreamViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "ProfileViewController.h"
#import "Dream.h"
#import "FileSystemManager.h"


@interface EditDreamViewController ()
{
    NSString *textFile;
    
    NSMutableArray *addedDreamContent;
    NSMutableArray *tags;
    NSMutableArray *hashTags;
    NSMutableArray *dreamCollection;
    
    ProfileViewController *profileViewController;
    
    Dream *dreamBeingAdded;
}

@property (weak, nonatomic) IBOutlet UITextView *dreamContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *stringHolder;
@property (nonatomic, strong) NSMutableArray *dreamList;

@end

@implementation EditDreamViewController

@synthesize keyboardToolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dreamContentTextView.delegate = self;
    self.textField.delegate = self;
    
    self.stringHolder = [NSString stringWithFormat:@""];
    
    profileViewController = [ProfileViewController new];
    
    tags = [NSMutableArray new];
    dreamCollection = [NSMutableArray new];
    hashTags = [[NSMutableArray alloc] init];
    addedDreamContent = [NSMutableArray new];
    
    //resign textView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //CORE DATA
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    dreamBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Dream" inManagedObjectContext:context];
    
    if (keyboardToolBar == nil) {
        keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        [keyboardToolBar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    }
    
    self.textField.inputAccessoryView = keyboardToolBar;
    self.dreamContentTextView.inputAccessoryView = keyboardToolBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Does audio file exist
    NSLog(@"audioFile exists? %@", self.audioURL);
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.audioURL.path])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.txtURL.path])
    {
        textFile = [NSString stringWithContentsOfURL:self.txtURL encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"textFile: %@", textFile);
        self.dreamContentTextView.text = textFile;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playTapped:(id)sender
{
    [self.playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
    NSLog(@"%@", self.audioURL);
    [self.player setDelegate:self];
    [self.player play];
}

- (void) dismissKeyboard
{
    [self.dreamContentTextView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"string holder = \"%@\"", self.stringHolder);
    NSLog(@"textField text = \"%@\"", textField.text);
    
    NSLog(@"New added string %@", [textField.text substringFromIndex:[self.stringHolder length]]);
    
    if (![textField.text isEqualToString:self.stringHolder]) {
        textField.text = [NSString stringWithFormat:@"%@#%@", self.stringHolder, [textField.text substringFromIndex:[self.stringHolder length]]];
    }
    
    NSLog(@"textField.text length: %d", [textField.text length]);
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

- (void)resignKeyboard:(id)sender
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    } else if ([self.dreamContentTextView isFirstResponder])
    {
        [self.dreamContentTextView resignFirstResponder];
    }
}

- (IBAction)saveTapped:(id)sender
{
    [self.dreamList addObject:dreamBeingAdded];
    dreamBeingAdded.pathToContent = self.dreamFolderPath;
    dreamBeingAdded.pathToRecording = self.audioURL.path;
    
    NSString *dreamContent = _dreamContentTextView.text;
    
    [[FileSystemManager sharedManager] newDreamTo:self.dreamFolderPath withContent:dreamContent];
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSError *error = nil;
    [context save:&error];
    if (error) {
        
    }
    
    NSLog(@"dreamBeingAdded: %@", dreamBeingAdded);
    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    self.dreamContentTextView.text = @"";
}

- (IBAction)unwindToEditDreamViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

@end
